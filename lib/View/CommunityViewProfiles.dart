import 'package:flutter/material.dart';
import '../Controller/YusrApp.dart';
import '../Controller/chatProvider.dart';
import '../Model/UserModel.dart';
import '../Model/chatRoomModel.dart';
import '../Model/messages_model.dart';
import 'CommunityViewFav.dart';
import 'chatView.dart';

class ViewProfileCommunity extends StatefulWidget {
  final CommunityUser;
  const ViewProfileCommunity(this.CommunityUser, {super.key});

  @override
  State<ViewProfileCommunity> createState() =>
      ViewProfileCommunityState(CommunityUser);
}

class ViewProfileCommunityState extends State<ViewProfileCommunity> {
  UserModel? CommunityUser;
  String name = "";
  String username = "";
  String imageUrl = '';
  String uid = '';

  ViewProfileCommunityState(CommunityUser) {
    this.CommunityUser = CommunityUser;
  }

  @override
  void initState() {
    super.initState();
    name = CommunityUser!.name!;
    username = CommunityUser!.username!;
    imageUrl = CommunityUser!.imagePath!;
    uid = CommunityUser!.uid!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 244, 240),
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0XFFd7ab65),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${username}',
          style: TextStyle(
              color: Color(0XFFd7ab65),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
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
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${name} ",
                      style: TextStyle(
                          color: Color(0XFFd7ab65), //Color(0xFF636363),
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${username} ",
                      style: TextStyle(
                          color: Color(0XFFd7ab65), //Color(0xFF636363),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Tajawal'),
                    )
                  ],
                )),
          ),

          Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCards("المفضلات", context),
                  ],
                )),
          ),
          const SizedBox(height: 5),
          Center(
            child: SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  await ChatProvider()
                      .createChatRoom(
                    chatType: "NormalChat",
                    chatRoom: ChatRoomModel(
                      senderId: YusrApp.loggedInUser.uid,
                      senderImg: YusrApp.loggedInUser.imagePath ?? '',
                      senderName: YusrApp.loggedInUser.name,
                      isDonation: false,
                      donationUserImg: imageUrl,
                      donationUserName: name,
                      donationUserId: uid,
                      message: MessageModel(
                        message: '',
                        readed: false,
                      ),
                    ),
                  )
                      .then((v) async {
                    ChatRoomModel room;

                    room = ChatRoomModel(
                      senderId: YusrApp.loggedInUser.uid,
                      senderImg: YusrApp.loggedInUser.imagePath ?? '',
                      senderName: YusrApp.loggedInUser.name,
                      isDonation: false,
                      donationUserImg: imageUrl,
                      donationUserName: username,
                      donationUserId: uid,
                      message: MessageModel(
                        message: '',
                        readed: false,
                      ),
                    );

                    String fcmToken = await YusrApp().getFCMUser(id: uid);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ChatScreen(
                                  room: room,
                                  isFromDonation: false,
                                  fcmToken: fcmToken,
                                )));
                  });
                },
                child: Text(
                  'إبدأ الدردشة',
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
                      return Color(0XFFd7ab65);
                    }),
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color(0XFFd7ab65), width: 1.0),
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
                if (title == "المفضلات")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
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
          onTap: () async {
            if (title == "المفضلات") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommunityViewFav(CommunityUser)),
              );
            }
          },
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
}
