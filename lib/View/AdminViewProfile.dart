import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/YusrApp.dart';
import '../main.dart';
import 'LoginPageView.dart';

class ViewProfileAdmin extends StatefulWidget {
  const ViewProfileAdmin({super.key});

  @override
  State<ViewProfileAdmin> createState() => _ViewProfileAdminState();
}

class _ViewProfileAdminState extends State<ViewProfileAdmin> {
  String name = "";
  String email = "";

  @override
  void initState() {
    name = YusrApp.loggedInAdmin.name!;
    email = YusrApp.loggedInAdmin.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 244, 240),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          // const SizedBox(height: 40),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/profile.png',
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${name} ",
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0XFFd7ab65), //Color(0xFF636363),
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${email} ",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0XFFd7ab65), //Color(0xFF636363),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(height: 6),
                  ],
                )),
          ),
          const SizedBox(height: 30),

          Center(
            //padding: EdgeInsets.only(top: 15.0, right: 90.0),
            child: SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text(
                            "هل تريد تسجيل الخروج؟",
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // AdminPreferences.RemovePref();
                                  logout(context);
                                  //FirebaseAuthMethods().signOut();

                                  Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return LoginPage();
                                    },
                                  ));
                                },
                                child: Text(
                                  "تسجيل خروج",
                                  style: TextStyle(
                                      color: Colors.red, fontFamily: 'Tajawal'),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "إلغاء",
                                  style: TextStyle(fontFamily: 'Tajawal'),
                                ))
                          ],
                        );
                      }));
                },
                child: Text(
                  'تسجيل الخروج',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Tajawal'),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey;
                      }
                      return Color.fromARGB(255, 214, 72, 72);
                    }),
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 214, 72, 72),
                            width: 1.0),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCards(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (title == "طلباتي")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.question_answer_rounded,
                      size: 30,
                      color: Color.fromARGB(163, 215, 171, 101),
                    ),
                  ),
                if (title == "مفضلتي")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                      color: Color.fromARGB(163, 215, 171, 101),
                    ),
                  ),
                if (title == "تعليقاتي")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.reviews_rounded,
                      size: 30,
                      color: Color.fromARGB(163, 215, 171, 101),
                    ),
                  ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  title,
                  style: new TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 58, 37, 1),
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  textDirection: TextDirection.ltr,
                  color: Color.fromARGB(
                      255, 58, 37, 1), //Color.fromARGB(255, 254, 177, 57),
                ),
              ],
            ),
          ),
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 241, 241, 241),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    editPrefs();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  editPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    admin = false;
    MyHomePageState.index = 0;
  }
}
