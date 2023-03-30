import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Controller/YusrApp.dart';
import '../Controller/chatProvider.dart';
import '../Model/DonationModel.dart';
import '../Model/chatRoomModel.dart';
import '../Model/messages_model.dart';
import 'chatView.dart';

class DonationPageUser extends StatefulWidget {
  const DonationPageUser({super.key});

  @override
  State<DonationPageUser> createState() => _DonationPageUserState();
}

class _DonationPageUserState extends State<DonationPageUser> {
  List Donations = [];
  bool noDonations = false;

  Future getDonationsList() async {
    var data = await FirebaseFirestore.instance
        .collection('Donation')
        .orderBy('AddDate')
        .get();

    if (this.mounted) {
      setState(() {
        Donations = List.from(data.docs.map((doc) => Donation.fromMap(doc)));

        if (Donations.length == 0) {
          noDonations = true;
        }
      });
    }
  }

  @override
  void initState() {
    getDonationsList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 244, 240),
        body: Container(
          width: 410,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: Donations.length,
              itemBuilder: (BuildContext context, int index) {
                var data = Donations[index];
                if (data.ownerId != YusrApp.loggedInUser.uid &&
                    data.isShow == true) {
                  return buildDonationCard(data, context);
                }
                if (data.ownerId == YusrApp.loggedInUser.uid &&
                    data.isShow == true) {
                  return buildMyDonationCard(data, context);
                }
                return nothing();
              }),
        ));
  }

  nothing() {
    return Container();
  }

  buildDonationCard(Donation data, context) {
    //DateTime addIn = data.AddDate.toDate();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(data.ProductImage, height: 130, width: 300),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'إسم المتبرع : ' + data.ownerName,
                  style: new TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'إسم المنتج : ' + data.ProductName,
                  style: new TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'تاريخ إنتهاء الصلاحية : ' + data.ExpDate,
                  style: new TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 77, 76, 76),
                      fontFamily: 'Tajawal'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'تاريخ التبرع : ' + data.AddDate,
                  //'${addIn.year.toString()}/${addIn.month.toString()}/${addIn.day.toString()}',
                  style: new TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 77, 76, 76),
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ChatProvider()
                            .createChatRoom(
                          chatType: "DonationChat",
                          chatRoom: ChatRoomModel(
                            senderId: YusrApp.loggedInUser.uid,
                            senderImg: YusrApp.loggedInUser.imagePath ?? '',
                            senderName: YusrApp.loggedInUser.name,
                            isDonation: true,
                            donationId: data.DonationId,
                            donationUserImg: data.ownerImage,
                            donationUserName: data.ownerName,
                            donationUserId: data.ownerId,
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
                            isDonation: true,
                            donationId: data.DonationId,
                            donationUserImg: data.ownerImage,
                            donationUserName: data.ownerName,
                            donationUserId: data.ownerId,
                            message: MessageModel(
                              message: '',
                              readed: false,
                            ),
                          );
                          String fcmToken =
                              await YusrApp().getFCMUser(id: data.ownerId);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => ChatScreen(
                                        room: room,
                                        isFromDonation: true,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Color(0XFFd7ab65), width: 1.0),
                            ),
                          )),
                    ),
                  ),
                )
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
              color: Color.fromARGB(81, 208, 208, 208),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }

  closeButton(isClosed, DonationId) {
    if (!isClosed) {
      return Center(
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
                        "هل تريد إغلاق التبرع؟",
                        style: TextStyle(fontFamily: 'Tajawal'),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              YusrApp().closeDonation(nameDoc: DonationId);
                              showConfirmation();
                            },
                            child: Text(
                              "إغلاق ",
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
              ' إغلاق التبرع',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Tajawal'),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
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
                        color: Color.fromARGB(255, 214, 72, 72), width: 1.0),
                  ),
                )),
          ),
        ),
      );
    }
  }

  buildMyDonationCard(Donation data, context) {
    //DateTime addIn = data.AddDate.toDate();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        children: [
          Container(
            child: new InkWell(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 20, right: 20),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(data.ProductImage, height: 130, width: 300),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'إسم المنتج : ' + data.ProductName,
                      style: new TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'تاريخ إنتهاء الصلاحية : ' + data.ExpDate,
                      style: new TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 77, 76, 76),
                          fontFamily: 'Tajawal'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'تاريخ التبرع : ' + data.AddDate,
                      //'${addIn.year.toString()}/${addIn.month.toString()}/${addIn.day.toString()}',
                      style: new TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 77, 76, 76),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    closeButton(data.isClosed, data.DonationId)
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
                  color: Color.fromARGB(81, 208, 208, 208),
                  offset: Offset.zero,
                  blurRadius: 20.0,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  showConfirmation() async {
    await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        desc: 'تم إغلاق عرض التبرع بنجاح',
        btnOkText: 'اغلاق',
        btnOkOnPress: () {
          MaterialPageRoute(builder: (context) => DonationPageUser());
        }).show();
  }
}
