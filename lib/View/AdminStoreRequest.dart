import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../Model/StoresRequest.dart';
import '../Widget/CardWidget.dart';

class AdminStoreRequestView extends StatefulWidget {
  final store;
  AdminStoreRequestView(this.store, {super.key});
  @override
  State<AdminStoreRequestView> createState() =>
      _TextfieldGeneralWidgetState(store);
}

class _TextfieldGeneralWidgetState extends State<AdminStoreRequestView> {
  StoresRequest? store;
  _TextfieldGeneralWidgetState(store) {
    this.store = store;
  }

  final storeController = TextEditingController();
  final storeDescriptionController = TextEditingController();

  String name = "";
  String fcmToken = "";

  @override
  void initState() {
    setName();
    super.initState();
  }

  @override
  void dispose() {
    storeController.dispose();
    storeDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            'عرض الطلب',
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
          padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.001,
              20,
              MediaQuery.of(context).size.height * 0.02),
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'رقم الطلب:' + " ${store!.StoreID}",
              style: TextStyle(
                  color: Color(0XFF81663C),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
            Text(
              'تاريخ الاضافة:' + " ${store!.dateAdd}",
              style: TextStyle(
                  color: Color(0XFF81663C),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
            Text(
              "تمت اضافته بواسطة: $name",
              style: TextStyle(
                  color: Color(0XFF81663C),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(thickness: 1.2),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.001,
                  20,
                  MediaQuery.of(context).size.height * 0.001),
              child: Row(
                children: [
                  CustomText("      صورة المتجر",
                      color: Color(0x8F909090).withOpacity(0.9),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Tajawal'),
                  SizedBox(
                    width: 45,
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(store!.imageStore),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                storeController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                store!.nameStore,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                storeDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                store!.desStore,
                "description",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0x76909090))),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: CustomText(
                      store!.state,
                      color: Colors.grey,
                      maxLines: 1,
                    )),
                    Icon(
                      Icons.location_on,
                      color: Color.fromRGBO(215, 171, 101, 1),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 0, 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        await AddStoreApproval(
                          store: store!,
                          kilometers: '10',
                          lat: 0,
                          lng: 0,
                        ).whenComplete(
                          () {
                            showConfirmation(
                                'تم اضافة المتجر بنجاح', 'اغلاق', context, '');
                          },
                        );
                      },
                      child: Text(
                        'قبول',
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
                            return Color.fromARGB(255, 9, 129, 45);
                          }),
                          elevation: MaterialStateProperty.all<double>(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 9, 129, 45),
                                  width: 1.0),
                            ),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 15, 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        await declineStore(store!, context).whenComplete(() {
                          showConfirmation(
                              'تم رفض طلب إضافة المتجر', 'اغلاق', context, '');
                        });
                      },
                      child: Text(
                        'رفض',
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
          ],
        ),
      );

  void setName() async {
    final res = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: "${store!.addByUid}")
        .get();

    try {
      setState(() {
        name = res.docs[0]['name'];
        fcmToken = res.docs[0]['fcmToken'];
      });
    } catch (e) {
      setState(() {
        name = "wrong";
      });
    }
  }

//--------------------------------------------------------------
  Future AddStoreApproval({
    required StoresRequest store,
    required String kilometers,
    required num lat,
    required num lng,
  }) async {
    await FirebaseFirestore.instance
        .collection("stores")
        .doc(store.StoreID)
        .set({
      'StoreId': store.StoreID,
      'StoreName': store.nameStore,
      'StoreLogo': store.imageStore,
      'description': store.desStore,
      'kilometers': kilometers,
      'lat': lat,
      'lng': lng,
    });
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('StoresRequest');
    await FirebaseFirestore.instance
        .collection('StoresRequest')
        .where('StoreID', isEqualTo: store.StoreID)
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference
                  .doc(element.id)
                  .update({"state": "new-approved"});
            }));
  }

  Future declineStore(StoresRequest store, BuildContext context) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('StoresRequest');

    await collectionReference
        .where('StoreID', isEqualTo: store.StoreID)
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference
                  .doc(element.id)
                  .update({"state": "new-declined"});
            }));
  }
}
