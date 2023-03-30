import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Model/UserModel.dart';
import '../Widget/CardWidget.dart';
import '../main.dart';

class CommunityPageAdmin extends StatefulWidget {
  const CommunityPageAdmin({super.key});

  @override
  State<CommunityPageAdmin> createState() => _CommunityPageAdminState();
}

class _CommunityPageAdminState extends State<CommunityPageAdmin> {
  String CurrentId = "";
  List<UserModel> Users = [];
  String SearchName = '';
  bool flag = false;
  int count = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    readUsers();
  }

  Stream<List<UserModel>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromARGB(255, 246, 244, 240),
        body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 0.0),
            child: Container(
              height: 800,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0XFFd7ab65), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0XFFd7ab65), width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x85747474), width: 1.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: ' ابحث عن معرف حساب محدد',
                        ),
                        onChanged: (val) {
                          setState(() {
                            SearchName = val;
                          });
                        },
                        style: TextStyle(fontFamily: 'Tajawal'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    width: 390,
                    child: StreamBuilder<List<UserModel>>(
                        stream: readUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final users = snapshot.data!;
                            count = users.length;
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = users[index];
                                  if (SearchName.isEmpty) {
                                    flag = false;
                                    return buildUsersCards(
                                        users[index], context);
                                  } else if (SearchName.isNotEmpty &&
                                      data.username
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(
                                              SearchName.toLowerCase())) {
                                    flag = true;
                                    return buildUsersCards(
                                        users[index], context);
                                  } else if (flag == false &&
                                      index == count - 1) {
                                    return Container(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'لا يوجد نتائج',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ));
                                  }
                                  return nothing();
                                });
                          } else if (snapshot.hasError) {
                            return Text(
                                "Some thing went wrong! ${snapshot.error}");
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ), /////
                ],
              ),
            )));
  }

  nothing() {
    return Container();
  }

  buildUsersCards(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: user.imagePath != null
                      ? NetworkImage(user.imagePath!)
                      : AssetImage("assets/profile.png") as ImageProvider,
                  radius: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ' ${user.name!}',
                      style: new TextStyle(
                        fontSize: 18,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          ' ' + user.username!,
                          style: new TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 77, 76, 76),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    size: 26,
                    Icons.delete_forever_outlined,
                    textDirection: TextDirection.ltr,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text(
                              "هل أنت متأكد من حذف ${user.username} ؟",
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    bool deleted = delete(user) as bool;
                                    if (deleted) {
                                      showConfirmation(
                                          'تم الحذف بنجاح',
                                          "إغلاق",
                                          _scaffoldKey.currentContext,
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage(title: '')),
                                          ));
                                    }
                                  },
                                  child: Text(
                                    "نعم",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Tajawal'),
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
                ),
                SizedBox(
                  width: 7,
                )
              ],
            ),
          ),
          onTap: () async {},
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(55, 187, 187, 187),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> delete(UserModel user) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      documents[0].reference.delete();
      return true;
    } else {
      return false;
    }
  }
}
