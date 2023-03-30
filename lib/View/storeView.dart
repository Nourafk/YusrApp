import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:yusr/Controller/YusrApp.dart';
import 'package:yusr/Model/ReviewModel.dart';
import 'package:yusr/Model/StoreModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yusr/main.dart';

class storeView extends StatefulWidget {
  final store;
  const storeView(this.store, {super.key});

  @override
  State<storeView> createState() => _storeViewState(store);
}

class _storeViewState extends State<storeView> {
  Store? store;
  _storeViewState(store) {
    this.store = store;
  }

  bool first = true;
  int reviewPoints = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(children: [
          Container(
            width: size.width,
            height: 300,
            child: Opacity(
              opacity: 0.7,
              child: Image.network(
                store!.StoreLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Opacity(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 20, 20, 20),
                  Colors.transparent
                ])),
                width: size.width,
                height: 300,
              ),
              opacity: 0.8),
          Padding(
            padding: const EdgeInsets.only(top: 70, right: 40),
            child: Opacity(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10), bottom: Radius.circular(10)),
                  color: Colors.white,
                ),
              ),
              opacity: 0.75,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 65, right: 36),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close_rounded,
                size: 33,
              ),
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 270, right: 40, left: 20),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Row(children: [
                      Text(
                        store!.StoreName,
                        style: new TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text('  ' + store!.kilometers + ' كم',
                          style: new TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 14,
                              color: Color.fromARGB(255, 77, 76, 76),
                              fontWeight: FontWeight.w400)),
                      Spacer(),
                      if (!admin)
                        Stack(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 19.0),
                            child: Icon(
                              Icons.add_comment_outlined,
                              color: Color.fromARGB(255, 104, 132, 168),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 11.0,
                            ),
                            child: TextButton(
                                onPressed: () {
                                  reviewPoints = 0;
                                  setReview(0);
                                  final _discriptionController =
                                      TextEditingController();

                                  showModalBottomSheet<void>(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            height: 450,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Container(
                                                      width: 130,
                                                      child: Divider(
                                                        thickness: 4,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 35,
                                                ),
                                                StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("stores")
                                                      .doc("store" +
                                                          store!.StoreID)
                                                      .collection("rates")
                                                      .where("username",
                                                          isEqualTo: YusrApp
                                                              .loggedInUser
                                                              .username)
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    if (snapshot.data == null) {
                                                      return Text("");
                                                    }
                                                    final review =
                                                        snapshot.data;

                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          isSelected: false,
                                                          icon: Icon(
                                                            review.docs.first[
                                                                        "rate"] >=
                                                                    1
                                                                ? Icons
                                                                    .star_rate_sharp
                                                                : Icons
                                                                    .star_border_outlined,
                                                            size: 45,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    243,
                                                                    196,
                                                                    89),
                                                          ),
                                                          onPressed: () {
                                                            reviewPoints = 1;
                                                            setReview(1);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            review.docs.first[
                                                                        "rate"] >=
                                                                    2
                                                                ? Icons
                                                                    .star_rate_sharp
                                                                : Icons
                                                                    .star_border_outlined,
                                                            size: 45,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    243,
                                                                    196,
                                                                    89),
                                                          ),
                                                          onPressed: () {
                                                            reviewPoints = 2;
                                                            setReview(2);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            review.docs.first[
                                                                        "rate"] >=
                                                                    3
                                                                ? Icons
                                                                    .star_rate_sharp
                                                                : Icons
                                                                    .star_border_outlined,
                                                            size: 45,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    243,
                                                                    196,
                                                                    89),
                                                          ),
                                                          onPressed: () {
                                                            reviewPoints = 3;
                                                            setReview(3);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            review.docs.first[
                                                                        "rate"] >=
                                                                    4
                                                                ? Icons
                                                                    .star_rate_sharp
                                                                : Icons
                                                                    .star_border_outlined,
                                                            size: 45,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    243,
                                                                    196,
                                                                    89),
                                                          ),
                                                          onPressed: () {
                                                            reviewPoints = 4;
                                                            setReview(4);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            review.docs.first[
                                                                        "rate"] >=
                                                                    5
                                                                ? Icons
                                                                    .star_rate_sharp
                                                                : Icons
                                                                    .star_border_outlined,
                                                            size: 45,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    243,
                                                                    196,
                                                                    89),
                                                          ),
                                                          onPressed: () {
                                                            reviewPoints = 5;
                                                            setReview(5);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Container(
                                                  width: 390,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.001,
                                                            20,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02),
                                                    child: TextFormField(
                                                      controller:
                                                          _discriptionController,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,

                                                      validator:
                                                          MultiValidator([
                                                        RequiredValidator(
                                                            errorText:
                                                                'مطلوب*'),
                                                        // PatternValidator(
                                                        //     r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_-\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]]*$',
                                                        //     errorText:
                                                        //         'يجب أن يتكون الأسم من حروف ')
                                                      ]),

                                                      cursorColor:
                                                          Color.fromARGB(
                                                              255, 37, 43, 121),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                                  255,
                                                                  15,
                                                                  53,
                                                                  120)
                                                              .withOpacity(
                                                                  0.9)),

                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        40.0),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            borderSide: const BorderSide(
                                                                color: Color(
                                                                    0XFFd7ab65),
                                                                width: 1.0)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color(
                                                                      0XFFd7ab65),
                                                                  width: 1.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color(
                                                                      0x76909090),
                                                                  width: 1.0),
                                                        ),
                                                        hintText:
                                                            "   اختر تقييمًا ثم أضف تعليقًا.",
                                                        hintStyle: TextStyle(
                                                          color: Color(
                                                                  0x8F909090)
                                                              .withOpacity(0.9),
                                                          fontFamily: 'Tajawal',
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white
                                                            .withOpacity(0.9),
                                                      ),

                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: null,
                                                      //--------------------------------------
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  width: 300,
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_discriptionController
                                                              .text
                                                              .isNotEmpty &&
                                                          reviewPoints != 0) {
                                                        Navigator.pop(context);
                                                        addReview(
                                                            _discriptionController
                                                                .text,
                                                            reviewPoints);
                                                        updatePoints();
                                                      } else if (_discriptionController
                                                              .text.isEmpty ||
                                                          reviewPoints == 0) {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                ((context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  reviewPoints ==
                                                                          0
                                                                      ? "   يرجى اختيار تقييم."
                                                                      : "   يرجى كتابة تعليق.",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Tajawal',
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'حسنًا',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                                                                            fontFamily: 'Tajawal'),
                                                                      )),
                                                                ],
                                                              );
                                                            }));
                                                      }
                                                      ////////////////
                                                      // checkNotNull();
                                                      // Navigator.pop(context);
                                                      // addReview(
                                                      //     _discriptionController
                                                      //         .text,
                                                      //     5);
                                                      // updatePoints();
                                                    },
                                                    child: Text(
                                                      'نـشـر  التقـيـيـم',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        fontFamily: 'Tajawal',
                                                      ),
                                                    ),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                                    (states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors.grey;
                                                          }
                                                          return Color(
                                                              0XFFd7ab65);
                                                        }),
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Text(" تقييم ",
                                    style: new TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 104, 132, 168),
                                    ))),
                          ),
                        ])
                    ]),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 54,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                  bottom: Radius.circular(25)),
                              border: Border.all(
                                  color: Color.fromARGB(255, 245, 206, 116),
                                  width: 3)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Icon(
                                    Icons.location_on,
                                    color: Color.fromARGB(255, 107, 33, 243),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String mapOptions = [
                                        'daddr=${store!.lat},${store!.lng}',
                                        'dir_action=navigate'
                                      ].join('&');

                                      final url =
                                          'https://www.google.com/maps?$mapOptions';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }

                                      // String url =
                                      //     'https://www.google.com/maps/search/?api=1&query=${store!.lat},${store!.lng}';
                                      // if (await canLaunchUrl(Uri.parse(url))) {
                                      //   await launchUrl(Uri.parse(url));
                                      // } else {
                                      //   throw 'Could not launch $url';
                                      // }
                                    },
                                    child: Text("فتح في خرائط قوقل ",
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Tajawal',
                                            color: Color.fromARGB(
                                                255, 33, 89, 243))),
                                  )
                                  //TextButton(onPressed: onPressed, child: child)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("من نحن",
                            style: new TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      store!.description,
                      textAlign: TextAlign.justify,
                      style: new TextStyle(fontFamily: 'Tajawal', fontSize: 17),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1.2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("التقييمات ",
                            style: new TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      child: StreamBuilder<List<Review>>(
                          stream: readReviews(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final reviews = snapshot.data!;
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: reviews.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Row(children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                reviews[index].imagePath),
                                            radius: 23,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(reviews[index].username,
                                              style: new TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Spacer(),
                                          Container(
                                            height: 40,
                                            width: 85,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(25),
                                                        bottom: Radius.circular(
                                                            25)),
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 245, 206, 116),
                                                    width: 2.5)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.star,
                                                      color: Color.fromARGB(
                                                          255, 245, 206, 116)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    reviews[index]
                                                        .rate
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 243, 196, 89),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          reviews[index].description,
                                          textAlign: TextAlign.justify,
                                          style: new TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              reviews[index].date,
                                              style: new TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  fontSize: 15),
                                            ),
                                            Spacer(),
                                            if (YusrApp.loggedInUser.username ==
                                                reviews[index].username)
                                              IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            height: 180,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: ((context) {
                                                                                return AlertDialog(
                                                                                  title: Text(
                                                                                    "هل تريد حذف تقييمك ؟",
                                                                                    style: TextStyle(fontFamily: 'Tajawal'),
                                                                                  ),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                          deleteItem(store!.StoreID, YusrApp.loggedInUser.username);
                                                                                        },
                                                                                        child: Text(
                                                                                          "نعم، قم بعملية الحذف",
                                                                                          style: TextStyle(color: Colors.red, fontFamily: 'Tajawal'),
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
                                                                        icon: Icon(
                                                                            Icons.delete)),
                                                                    TextButton(
                                                                      child:
                                                                          Text(
                                                                        "حذف التقييم",
                                                                        style: new TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontFamily:
                                                                                'Tajawal',
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w200),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                ((context) {
                                                                              return AlertDialog(
                                                                                title: Text(
                                                                                  "هل تريد حذف تقييمك ؟",
                                                                                  style: TextStyle(fontFamily: 'Tajawal'),
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                        deleteItem(store!.StoreID, YusrApp.loggedInUser.username);
                                                                                      },
                                                                                      child: Text(
                                                                                        "نعم، قم بعملية الحذف",
                                                                                        style: TextStyle(color: Colors.red, fontFamily: 'Tajawal'),
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
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed: () =>
                                                                            Navigator.pop(
                                                                                context),
                                                                        icon: Icon(
                                                                            Icons.close)),
                                                                    TextButton(
                                                                      child:
                                                                          Text(
                                                                        "إلغاء",
                                                                        style: new TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontFamily:
                                                                                'Tajawal',
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w200),
                                                                      ),
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(Icons.more_horiz))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return Text(
                                  "Some thing went wrong! ${snapshot.error}");
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ),
                    Text("\n\n\n")
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  Stream<List<Review>> readReviews() => FirebaseFirestore.instance
      .collection('stores')
      .doc("store" + store!.StoreID)
      .collection('reviews')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());

  Future addReview(String description, int rate) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String todayDate = formatter.format(now);

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("stores");
    _collectionRef.doc("store" + store!.StoreID).collection("reviews").add({
      "username": YusrApp.loggedInUser.username,
      "description": description,
      "imagePath": YusrApp.loggedInUser.imagePath,
      "date": todayDate,
      "rate": rate,
    });
  }

  Future setReview(int rate) async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("stores")
        .doc("store" + store!.StoreID)
        .collection("rates");
    if (first) {
      _collectionRef
          .add({"username": YusrApp.loggedInUser.username, "rate": rate});
      setState(() {
        first = false;
      });
    } else {
      final QuerySnapshot result = await _collectionRef
          .where("username", isEqualTo: YusrApp.loggedInUser.username)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      documents[0].reference.update({
        "rate": rate,
      });
    }
  }

  void updatePoints() async {
    Future<void> result = FirebaseFirestore.instance
        .collection("users")
        .doc(YusrApp.loggedInUser.uid)
        .update({
      "points": FieldValue.increment(1),
    });
  }
}

Future<bool> deleteItem(String id, String? username) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection("stores")
      .doc("store$id")
      .collection("reviews")
      .where("username", isEqualTo: username)
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.isNotEmpty) {
    documents[0].reference.delete();
    return true;
  } else {
    return false;
  }
}
