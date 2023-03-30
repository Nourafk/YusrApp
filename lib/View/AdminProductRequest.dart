import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Model/ProductRequest.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../Widget/CardWidget.dart';

class AdminProductRequestView extends StatefulWidget {
  final product;
  AdminProductRequestView(this.product, {super.key});
  @override
  State<AdminProductRequestView> createState() =>
      _TextfieldGeneralWidgetState(product);
}

class _TextfieldGeneralWidgetState extends State<AdminProductRequestView> {
  ProductsRequest? product;
  _TextfieldGeneralWidgetState(product) {
    this.product = product;
  }

  final productController = TextEditingController();
  final productDescriptionController = TextEditingController();
  String name = "";
  String fcmToken = "";

  @override
  void initState() {
    setName();
    super.initState();
  }

  @override
  void dispose() {
    productController.dispose();
    productDescriptionController.dispose();
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
              'رقم الطلب:' + " ${product!.ProductID}",
              style: TextStyle(
                  color: Color(0XFF81663C),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
            Text(
              'تاريخ الاضافة:' + " ${product!.dateAdd}",
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
                  CustomText("      صورة المنتج",
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
                          image: NetworkImage(product!.imageProduct),
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
                productController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                product!.nameProduct,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                productDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                product!.callories + ' cal',
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                productDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                product!.productType,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 0, 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        AddProductApproval(product: product!).whenComplete(
                          () {
                            showConfirmation(
                                'تمت إضافة المنتج بنجاح', 'إغلاق', context, '');
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
                        await declineProduct(product!);
                        showConfirmation(
                            'تم رفض طلب إضافة المنتج ', 'إغلاق', context, '');
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
        .where('uid', isEqualTo: "${product!.addByUid}")
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

  //----------------------------------------------------
  Future AddProductApproval({required ProductsRequest product}) async {
    String col = '';
    if (product.productType == "المعكرونة")
      col = "pasta";
    else if (product.productType == "المخبوزات")
      col = "bread";
    else if (product.productType == "الحلويات")
      col = "sweets";
    else if (product.productType == "وجبات خفيفة")
      col = "snacks";
    else if (product.productType == "طحين") col = "Flour";
    await FirebaseFirestore.instance
        .collection("products")
        .doc('product1')
        .collection(col)
        .doc(product.ProductID)
        .set({
      'ProductID': product.ProductID,
      'ProductName': product.nameProduct,
      'ProductPhoto': product.imageProduct,
      'callories': product.callories,
    });
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('ProductRequest');

    await collectionReference
        .where('ProductID', isEqualTo: product.ProductID)
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference
                  .doc(element.id)
                  .update({"state": "new-approved"});
            }));
  }

  Future declineProduct(ProductsRequest product) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('ProductRequest');

    await collectionReference
        .where('ProductID', isEqualTo: product.ProductID)
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference
                  .doc(element.id)
                  .update({"state": "new-declined"});
            }));
  }
}
