import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/View/UserViewProfile.dart';
import 'Controller/Notification_Api.dart';
import 'Controller/YusrApp.dart';
import 'Model/AdminModel.dart';
import 'Model/UserModel.dart';
import 'View/AddDonation.dart';
import 'View/AdminViewCommunity.dart';
import 'View/AdminViewRequests.dart';
import 'View/AdminViewProfile.dart';
import 'View/CommunityView.dart';
import 'View/DonationView.dart';
import 'View/UserHomePageView.dart';
import 'View/LoginPageView.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'View/TextRecognitionView.dart';
import 'View/mainChatRooms.dart';
import 'package:timezone/data/latest.dart' as tz;

bool admin = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  if (email == 'admin@yusr.com') {
    admin = true;
  }
  print(email);
  tz.initializeTimeZones();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  String fcmToken;

  FirebaseMessaging.onMessage.listen((message) {
    // Handle your message here
    log("fcmToken: ${message.data}");
  });

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  _fcm.getToken().then((token) async {
    log("fcmToken: ${token}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', token!);
    fcmToken = token;

    if (FirebaseAuth.instance.currentUser != null) {
      await YusrApp().updateFCMUser(id: FirebaseAuth.instance.currentUser!.uid);
    }
    //
  });

  runApp(MaterialApp(localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ], supportedLocales: [
    Locale('ar', 'AE'),
  ], home: email == null ? LoginPage() : MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'EN'), // English, no country code
      ],
      debugShowCheckedModeBanner: false, // English, no country code
      home: const MyHomePage(
        title: '',
      ),
    );
  }
}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("sssss_myBackgroundMessageHandler ");
  // Or do other work.
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static Position? currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    if (!admin) {
      print(user);
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        setState(() {
          YusrApp.loggedInUser = UserModel.fromMap(value.data());
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection("admins")
          .doc('admin1')
          .get()
          .then((value) {
        setState(() {
          YusrApp.loggedInAdmin = AdminModel.fromMap(value.data());
        });
      });
    }
    _getCurrentPosition();
    readStores;
    if (!admin) {
      checkRequestUpdated("ProductRequest");
      checkRequestUpdated("RecipeRequest");
      checkRequestUpdated("StoresRequest");
    }
    NotificationApi.init(initScheduled: true);
  }

  static int index = 0;
  final screens1 = [
    HomePageUser(),
    CommunityPageUser(),
    TextRecognitionPageUser(),
    DonationPageUser(),
    ViewProfileUser()
  ];
  final screens2 = [
    HomePageUser(),
    CommunityPageAdmin(),
    RequestsPageAdmin(),
    ViewProfileAdmin()
  ];
  final titles1 = [
    "مرحبًا، ",
    "المجتمع",
    "الكشف عن الجلوتين",
    "التبرعات",
    "حسابي"
  ];
  final titles2 = ["مرحبًا، ", "المجتمع", "طلبات الإضافة", "حسابي"];
  @override
  Widget build(BuildContext context) {
    UserModel userInfo = YusrApp.loggedInUser;
    AdminModel adminInfo = YusrApp.loggedInAdmin;
    final items1 = <Widget>[
      Icon(
        Icons.home,
        size: 30,
      ),
      Icon(
        Icons.groups_rounded,
        size: 30,
      ),
      Icon(
        Icons.document_scanner,
        size: 30,
      ),
      ImageIcon(
        AssetImage('assets/donate.png'),
        size: 30,
      ),
      Icon(
        Icons.person,
        size: 30,
      ),
    ];

    final items2 = <Widget>[
      Icon(
        Icons.home,
        size: 30,
      ),
      Icon(
        Icons.groups_rounded,
        size: 30,
      ),
      Icon(
        CupertinoIcons.time_solid,
        size: 30,
      ),
      Icon(
        Icons.person,
        size: 30,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: admin == true
          ? adminAppBarChoice(adminInfo.name)
          : UserAppBarChoice(
              userInfo.name, userInfo.imagePath, userInfo.points),
      body: SafeArea(child: admin == true ? screens2[index] : screens1[index]),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          color: Color(0XFFd7ab65),
          buttonBackgroundColor: Color(0XFFd7ab65), //Color(0XFFf3bb12),
          backgroundColor:
              Color.fromARGB(255, 246, 244, 240), //Color(0XFFf3bb12),
          height: Platform.isAndroid ? 60 : 75,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 400),
          index: index,
          items: admin == true ? items2 : items1,
          onTap: (index) => setState(() {
            MyHomePageState.index = index;
          }),
        ),
      ),
    );
  }

  checkRequestUpdated(String type) async {
    var collection = FirebaseFirestore.instance
        .collection(type)
        .where("addByUid", isEqualTo: user!.uid);
    collection.snapshots().listen((docSnapshot) {
      String state = docSnapshot.docChanges.last.doc.get("state");
      if (state == "new-approved" || state == "new-declined") {
        NotificationApi.showScheduledNotification(
            title:
                'مرحباً ${YusrApp.loggedInUser.name}، لقد تغيرت حالة طلبك للإضافة !!',
            body: 'تعال وانظر ما هي حالة طلبك الجديدة!',
            payload: 'paylod.nav',
            scheduledDate: DateTime.now().add(Duration(seconds: 1)));
      }
    });
  }

  UserAppBarChoice(name, image, points) {
    if (index > 1 && index != 3) {
      return AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Text(
          titles1[index],
          style: TextStyle(
              color: Color(0XFFd7ab65),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      );
    }
    if (index == 3) {
      return AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Text(
          titles1[index],
          style: TextStyle(
              color: Color(0XFFd7ab65),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddDonation()),
                    );
                  },
                  icon: Icon(Icons.add_box_outlined),
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 38, left: 8),
                child: Text("إضافة تبرع",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
              )
            ],
          )
        ],
      );
    } else if (index == 0 && image != null) {
      return AppBar(
        leading: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 23,
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "مرحبًا،",
                  style: TextStyle(
                      color: Color(0XFFd7ab65), //Color(0xFF636363),
                      fontSize: 23,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Tajawal'),
                ),
              ],
            ),
            Text(
              "${name ?? ""}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color(0XFFd7ab65), //Color(0xFF636363),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal'),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "نقاطي ",
                      style: TextStyle(
                          color: Color(0XFFd7ab65), //Color(0xFF636363),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "${points}",
                        style: TextStyle(
                            color: Color(0XFFd7ab65), //Color(0xFF636363),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal'),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.gift,
                      size: 20,
                      color: Color(0XFFd7ab65),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    }
    if (index == 0 && image == null) {
      return AppBar(
        leading: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
              radius: 23,
            ),
          ],
        ),
        title: Text(
          "مرحبًا، ${name}",
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Color(0XFFd7ab65), //Color(0xFF636363),
              fontSize: 26,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "نقاطي ",
                      style: TextStyle(
                          color: Color(0XFFd7ab65), //Color(0xFF636363),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "${points}",
                        style: TextStyle(
                            color: Color(0XFFd7ab65), //Color(0xFF636363),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal'),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.gift,
                      size: 20,
                      color: Color(0XFFd7ab65),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    } else if (index == 1) {
      return AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 9.0),
            child: IconButton(
              icon: Icon(
                Icons.mark_unread_chat_alt_outlined,
                color: Color(0XFFd7ab65),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainChatRooms()));
              },
            ),
          )
        ],
        title: Text(
          titles1[index],
          style: TextStyle(
              color: Color(0XFFd7ab65),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      );
    }
  }

  adminAppBarChoice(name) {
    if (index > 0) {
      return AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Text(
          titles2[index],
          style: TextStyle(
              color: Color(0XFFd7ab65),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      );
    } else if (index == 0) {
      return AppBar(
        leading: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
              radius: 23,
            ),
          ],
        ),
        title: Text(
          "مرحبًا، $name",
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Color(0XFFd7ab65), //Color(0xFF636363),
              fontSize: 26,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 0,
      );
    }
  }

  static Stream readStores = FirebaseFirestore.instance
      .collection('stores')
      .snapshots()
      .map((list) => list.docs.map((doc) => doc.data()).toList());
}
