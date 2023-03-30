import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Controller/YusrApp.dart';
import 'package:yusr/Model/RecipeModel.dart';
import 'package:yusr/Model/StoreModel.dart';
import 'package:yusr/View/AdminRecipeRequestView.dart';
import 'package:yusr/View/StoreRequestView.dart';
import 'package:yusr/View/storeView.dart';
import 'package:yusr/main.dart';
import '../View/AdminProductRequest.dart';
import '../View/AdminStoreRequest.dart';
import '../View/ProductRequestView.dart';
import '../View/RecipeRequestView.dart';
import '../View/recipeView.dart';

Widget buildCard(
    String Category,
    String ID,
    String Name,
    String Photo,
    String kilometers,
    String description,
    String callories,
    String ingredients,
    String time,
    String persons,
    num lat,
    num lng,
    Function addToFav,
    Function removeFromFav,
    BuildContext context) {
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
              Image.network(
                Photo,
                width: 60,
                height: 60,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ' ' + Name,
                      style: new TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    if (Category == "store")
                      Row(
                        children: <Widget>[
                          Text(
                            ' ' + kilometers + ' كم',
                            style: new TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 77, 76, 76),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    if (Category == "recipie")
                      Text(
                        ' ' + description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: new TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 7,
                    ),
                    if (callories != "")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ' ' + callories,
                            style: new TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 77, 76, 76),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Text(
                            ' سعرة حرارية',
                            style: new TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 77, 76, 76),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (admin == false)
                StreamBuilder(
                  stream: Category == "store"
                      ? FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("FavStores")
                          .where("StoreId", isEqualTo: ID)
                          .snapshots()
                      : Category == "product"
                          ? FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("FavProducts")
                              .where("ProductID", isEqualTo: ID)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("FavRecipes")
                              .where("RecipeID", isEqualTo: ID)
                              .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Text("");
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 0, right: 3),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            if (snapshot.data.docs.length == 0) {
                              addToFav();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'سيتمكن أعضاء المجتمع من مشاهدة مفضلاتك!'),
                                duration: Duration(seconds: 3),
                              ));
                            } else {
                              removeFromFav();
                            }
                          },
                          icon: snapshot.data.docs.length == 0
                              ? Icon(
                                  Icons.favorite_outline,
                                  color: Color.fromARGB(255, 17, 15, 15),
                                )
                              : Icon(
                                  Icons.favorite,
                                  color: Color.fromARGB(255, 193, 40, 30),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              if (admin == true) //admin side
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text(
                              "هل أنت متأكد من حذف $Name ؟",
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    deleteItem(Name, Category);
                                    await AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            animType: AnimType.bottomSlide,
                                            desc: 'تم الحذف بنجاح',
                                            descTextStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Tajawal'),
                                            btnOkText: "إغلاق",
                                            buttonsTextStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Tajawal'),
                                            btnOkOnPress: () {})
                                        .show();
                                    Navigator.pop(context);
                                    // showConfirmation(
                                    //     'تم الحذف بنجاح', "إغلاق", context, '');
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
                  icon: Icon(
                    size: 26,
                    Icons.delete_forever_outlined,
                    textDirection: TextDirection.ltr,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              SizedBox(
                width: 7,
              )
            ],
          ),
        ),
        onTap: () async {
          if (Category == "recipie") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => recipeView(Recipe(
                        RecipeID: "",
                        RecipeName: Name,
                        RecipePhoto: Photo,
                        description: description,
                        callories: callories,
                        ingredients: ingredients,
                        time: time,
                        persons: persons,
                      ))),
            );
          } else if (Category == "store") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => storeView(Store(
                          StoreID: ID,
                          StoreLogo: Photo,
                          StoreName: Name,
                          kilometers: kilometers,
                          lat: lat,
                          lng: lng,
                          description: description,
                        ))));
          }
        },
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

showConfirmation(description, btn, context, action) async {
  await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      desc: description,
      descTextStyle: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
      btnOkText: btn,
      buttonsTextStyle: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
      btnOkOnPress: () {
        if (action == '') {
          Navigator.pop(context);
        } else {
          action;
        }
      }).show();
}

Future<bool> deleteItem(String Name, String Category) async {
  if (Category == "store") {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(Category + "s")
        .where("StoreName", isEqualTo: Name)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      documents[0].reference.delete();
      return true;
    } else {
      return false;
    }
  } else if (Category == "product") {
    String col = "";
    if (YusrApp.categoryIndex == 0) {
      col = 'pasta';
    } else if (YusrApp.categoryIndex == 1) {
      col = 'snacks';
    } else if (YusrApp.categoryIndex == 2) {
      col = 'sweets';
    } else if (YusrApp.categoryIndex == 3) {
      col = 'bread';
    } else if (YusrApp.categoryIndex == 4) {
      col = 'Flour';
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(Category + "s")
        .doc(Category + "1")
        .collection(col)
        .where("ProductName", isEqualTo: Name)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      documents[0].reference.delete();
      return true;
    } else {
      return false;
    }
  } else {
    String col = "";
    if (YusrApp.categoryIndex == 0) {
      col = 'Essential';
    } else if (YusrApp.categoryIndex == 1) {
      col = 'snacks';
    } else if (YusrApp.categoryIndex == 2) {
      col = 'pasta';
    } else if (YusrApp.categoryIndex == 3) {
      col = 'desserts';
    } else if (YusrApp.categoryIndex == 4) {
      col = 'bread';
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(Category + "s")
        .doc("recipe1")
        .collection(col)
        .where("RecipeName", isEqualTo: Name)
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

//-----------------------------------#############################################################
Widget buildCardRequestUser(String date, String ID, String state, String type,
    Object object, BuildContext context) {
  inWhichCase(state);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
    child: InkWell(
      child: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.receipt_sharp,
                    size: 40,
                    color: Color.fromARGB(163, 215, 171, 101),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'رقم الطلب : ' + ID,
                        style: new TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        'تاريخ الطلب : ' + date,
                        style: new TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    textDirection: TextDirection.ltr,
                    color: Color.fromARGB(163, 215, 171, 101),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),
              //-----------------------------------------------------------------------------------------

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (inCase1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('تحت الدراسة'),
                          //  Text('جاهزة للاستلام'),
                          //  Text('تم الإسترجاع'),
                        ],
                      ),
                    if (inCase2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('          '),
                          Text('          '),
                          Text('مرفوض '),
                          //  Text('إغلاق الطلب'),
                        ],
                      ),
                    if (inCase3)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('         '),
                          Text('          '),
                          // Text(' مقبول  '),
                          Text('تمت الإضافة'),
                        ],
                      ),

                    const SizedBox(
                      height: 10,
                    ),
                    if (inCase1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 8,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              color: Color.fromARGB(255, 137, 165, 158),
                              height: 2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 14,
                            child: Icon(Icons.timelapse,
                                size: 16, color: Colors.white),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              color: Color.fromARGB(255, 225, 208, 186),
                              height: 2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 225, 208, 186),
                            radius: 8,
                          ),
                        ],
                      ),
                    if (inCase2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 8,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              color: Color.fromARGB(255, 137, 165, 158),
                              height: 2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 14,
                            child: Icon(Icons.timelapse,
                                size: 16, color: Colors.white),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              color: const Color.fromARGB(255, 255, 106, 106),
                              height: 2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 255, 106, 106),
                            radius: 14,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    if (inCase3)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 8,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              color: Color.fromARGB(255, 137, 165, 158),
                              height: 2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 14,
                            child: Icon(Icons.timelapse,
                                size: 16, color: Colors.white),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              color: Color.fromARGB(255, 137, 165, 158),
                              height: 2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 137, 165, 158),
                            radius: 14,
                            child:
                                Icon(Icons.done, size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    //  +++++++++++++++++++++++++++++++
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              //   ],
              // ),
            ],
          ),
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
      onTap: () {
        if (type == "store") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoreRequest(object)),
          );
        } else if (type == "product") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductRequest(object)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeRequest(object)),
          );
        }
      },
    ),
  );
}

bool inCase1 = true;
bool inCase2 = false;
bool inCase3 = false;

void inWhichCase(status) {
  if (status == '') {
    //pending
    inCase1 = true;
    inCase2 = false;
    inCase3 = false;
  }
  if (status == 'declined') {
    inCase1 = false;
    inCase2 = true;
    inCase3 = false;
  }
  if (status == 'approved') {
    inCase1 = false;
    inCase2 = false;
    inCase3 = true;
  }
}

Widget buildCardRequest(
    String date, String ID, String type, Object object, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
    child: InkWell(
      child: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Icon(
                Icons.receipt_sharp,
                size: 40,
                color: Color.fromARGB(163, 215, 171, 101),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'رقم الطلب : ' + ID,
                    style: new TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'تاريخ الطلب : ' + date,
                    style: new TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_back_ios_rounded,
                textDirection: TextDirection.ltr,
                color: Color.fromARGB(163, 215, 171, 101),
              ),
            ],
          ),
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
      onTap: () {
        if (type == "store") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminStoreRequestView(object)),
          );
        } else if (type == "product") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminProductRequestView(object)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminRecipeRequestView(object)),
          );
        }
      },
    ),
  );
}
