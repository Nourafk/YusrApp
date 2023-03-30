import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Controller/YusrApp.dart';
import '../Model/DonationModel.dart';
import '../Widget/CardWidget.dart';

class MyDonation extends StatefulWidget {
  const MyDonation({super.key});

  @override
  State<MyDonation> createState() => _MyDonationState();
}

class _MyDonationState extends State<MyDonation> {
  List myDonations = [];
  bool noDonations = false;

  Future getDonationsList() async {
    var data = await FirebaseFirestore.instance
        .collection('Donation')
        .orderBy('AddDate')
        .get();

    if (this.mounted) {
      setState(() {
        myDonations = List.from(data.docs.map((doc) => Donation.fromMap(doc)));

        if (myDonations.length == 0) {
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
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0XFFd7ab65),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'تبرعاتي',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (noDonations == true)
                Container(
                  height: 200,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 97),
                          child: Text(
                            "لا يوجد عروض تبرع",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Tajawal'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (noDonations == false)
                Container(
                    height: 800,
                    width: 410,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: myDonations.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = myDonations[index];
                          if (data.ownerId == YusrApp.loggedInUser.uid) {
                            return buildDonationCard(data, context);
                          }
                          return nothing();
                        }))
              // showDonations(),
            ],
          ),
        ));
  }

  nothing() {
    return Container();
  }

  buildDonationCard(Donation data, context) {
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
                            onPressed: () async {
                              Navigator.pop(context);
                              YusrApp().closeDonation(nameDoc: DonationId);
                              showConfirmation(
                                  'تم إغلاق عرض التبرع بنجاح',
                                  'اغلاق',
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyDonation(),
                                  ));
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
    } else {
      return Center(
        child: SizedBox(
          width: 300,
          height: 40,
          child: ElevatedButton(
            onPressed: () async {},
            child: Text(
              ' تم إغلاق التبرع ',
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
                  return Colors.grey;
                }),
                elevation: MaterialStateProperty.all<double>(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                )),
          ),
        ),
      );
    }
  }

  showDonations() {
    getDonationsList();
    return Container(
        height: 900,
        width: 360,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: myDonations.length,
            itemBuilder: (BuildContext context, int index) {
              var data = myDonations[index];
              if (data.ownerId == YusrApp.loggedInUser.uid) {
                return buildDonationCard(data, context);
              }
              return nothing();
            }));
  }
}
