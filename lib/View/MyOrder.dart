import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Controller/YusrApp.dart';
import '../Model/ProductRequest.dart';
import '../Model/RecipeRequest.dart';
import '../Model/StoresRequest.dart';
import '../Widget/CardWidget.dart';

class MyOrder extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<MyOrder> {
  User? user = FirebaseAuth.instance.currentUser;

  List<RecipesRequest> RecipesReq = [];
  List MyRecipesReq = [];
  bool noRecipesReqList = false;

  bool inCase1 = false;
  bool inCase2 = false;
  bool inCase3 = false;

  void inWhichCase(status) {
    if (status == '') {
      //pending
      inCase1 = true;
      inCase2 = false;
      inCase3 = false;
    }
    if (status == 'declined' || status == 'new-declined') {
      inCase1 = false;
      inCase2 = true;
      inCase3 = false;
    }
    if (status == 'approved' || status == 'new-approved') {
      inCase1 = false;
      inCase2 = false;
      inCase3 = true;
    }
  }

  Future getRecipesReqList() async {
    print('object');
    var data =
        await FirebaseFirestore.instance.collection("RecipeRequest").get();

    setState(() {
      RecipesReq =
          List.from(data.docs.map((doc) => RecipesRequest.fromMap(doc)));
      if (RecipesReq.length != 0) {
        for (int i = 0; i < RecipesReq.length; i++) {
          if (RecipesReq[i]
              .addByUid
              .contains(YusrApp.loggedInUser.uid as String)) {
            MyRecipesReq.add(RecipesReq[i]);
          }
        }
      }
      if (MyRecipesReq.length == 0) {
        noRecipesReqList = true;
      }
    });
  }

  List<ProductsRequest> ProductReq = [];
  List MyProductReq = [];
  bool noProductReqList = false;

  Future getProductReqList() async {
    var data =
        await FirebaseFirestore.instance.collection("ProductRequest").get();

    setState(() {
      ProductReq =
          List.from(data.docs.map((doc) => ProductsRequest.fromMap(doc)));
      if (ProductReq.length != 0) {
        for (int i = 0; i < ProductReq.length; i++) {
          if (ProductReq[i]
              .addByUid
              .contains(YusrApp.loggedInUser.uid as String)) {
            MyProductReq.add(ProductReq[i]);
          }
        }
      }

      if (MyProductReq.length == 0) {
        noProductReqList = true;
      }
    });
  }

  List<StoresRequest> StoreReq = [];
  List MyStoreReq = [];
  bool noStoreReqList = false;

  Future getStoreReqList() async {
    var data =
        await FirebaseFirestore.instance.collection("StoresRequest").get();

    setState(() {
      StoreReq = List.from(data.docs.map((doc) => StoresRequest.fromMap(doc)));
      if (StoreReq.length != 0) {
        for (int i = 0; i < StoreReq.length; i++) {
          if (StoreReq[i]
              .addByUid
              .contains(YusrApp.loggedInUser.uid as String)) {
            MyStoreReq.add(StoreReq[i]);
          }
        }
      }

      if (MyStoreReq.length == 0) {
        noStoreReqList = true;
      }
    });
  }

  @override
  void initState() {
    getStoreReqList();
    getProductReqList();
    getRecipesReqList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
          'طلباتي',
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
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).size.height * 0.001,
                    20,
                    MediaQuery.of(context).size.height * 0.001),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          YusrApp.categoryIndex = 0;
                        });
                      },
                      child: Text(
                        "المتاجر",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 21, 42, 86),
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            fontFamily: 'Tajawal'),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return YusrApp.categoryIndex == 0
                              ? Color.fromARGB(128, 239, 197, 99)
                              : Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0x4DA7A7A7), width: 2.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          YusrApp.categoryIndex = 1;
                        });
                      },
                      child: Text(
                        "المنتجات",
                        style: const TextStyle(
                            color: Color.fromARGB(
                                255, 21, 42, 86), //Colors.orange,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            fontFamily: 'Tajawal'),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return YusrApp.categoryIndex == 1
                              ? Color.fromARGB(128, 239, 197, 99)
                              : Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0x4DA7A7A7), width: 2.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          YusrApp.categoryIndex = 2;
                        });
                      },
                      child: Text(
                        "الوصفات",
                        style: const TextStyle(
                            color: Color.fromARGB(
                                255, 21, 42, 86), //Colors.orange,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            fontFamily: 'Tajawal'),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return YusrApp.categoryIndex == 2
                              ? Color.fromARGB(128, 239, 197, 99)
                              : Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0x4DA7A7A7), width: 2.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (YusrApp.categoryIndex == 0 && noStoreReqList == true)
                Container(
                  height: 200,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 97),
                          child: Text(
                            'لا يوجد طلبات إضافة متجر',
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
              if (YusrApp.categoryIndex == 0 && noStoreReqList == false)
                showStores(),
              if (YusrApp.categoryIndex == 1 && noProductReqList == true)
                Container(
                  height: 200,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 97),
                        child: Text(
                          'لا يوجد طلبات إضافة منتح',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Tajawal'),
                        ),
                      ),
                    ],
                  )),
                ),
              if (YusrApp.categoryIndex == 1 && noProductReqList == false)
                showProducts(),
              if (YusrApp.categoryIndex == 2 && noRecipesReqList == true)
                Container(
                    height: 200,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 97),
                            child: Text(
                              'لا يوجد طلبات إضافة وصفة',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Tajawal'),
                            ),
                          ),
                        ],
                      ),
                    )),
              if (YusrApp.categoryIndex == 2 && noRecipesReqList == false)
                showRecipes(),
            ],
          ),
        ),
      ));

  showStores() {
    return Container(
      height: 700,
      width: 390,
      child: SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: MyStoreReq.length,
              itemBuilder: (BuildContext context, int index) {
                var data = MyStoreReq[index];
                SizedBox(
                  height: 10,
                );
                if (data.addByUid == YusrApp.loggedInUser.uid) {
                  return buildCardRequestUser(
                      MyStoreReq[index].dateAdd,
                      MyStoreReq[index].StoreID,
                      MyStoreReq[index].state,
                      "store",
                      StoresRequest(
                          imageStore: MyStoreReq[index].imageStore,
                          desStore: MyStoreReq[index].desStore,
                          dateAdd: MyStoreReq[index].dateAdd,
                          state:
                              'منطقة الرياض، 3429 شارع عبدالرحمن بن علي ال الشيخ',
                          nameStore: MyStoreReq[index].nameStore,
                          addByUid: MyStoreReq[index].addByUid,
                          isShow: MyStoreReq[index].isShow,
                          StoreID: MyStoreReq[index].StoreID),
                      context);
                }
                return Container();
              })),
    );
  }

  showRecipes() {
    return Container(
      height: 700,
      width: 390,
      child: SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: RecipesReq.length,
              itemBuilder: (BuildContext context, int index) {
                var data = RecipesReq[index];
                SizedBox(
                  height: 10,
                );
                if (data.addByUid == YusrApp.loggedInUser.uid) {
                  return buildCardRequestUser(
                      RecipesReq[index].dateAdd,
                      RecipesReq[index].RecipeId,
                      RecipesReq[index].state,
                      "recipe",
                      RecipesRequest(
                          imageRecipe: RecipesReq[index].imageRecipe,
                          nutritionalInformationRecipe:
                              RecipesReq[index].nutritionalInformationRecipe,
                          ingredientsRecipe:
                              RecipesReq[index].ingredientsRecipe,
                          timeEndRecipe: RecipesReq[index].timeEndRecipe,
                          recipeType: RecipesReq[index].recipeType,
                          nameRecipe: RecipesReq[index].nameRecipe,
                          dateAdd: RecipesReq[index].dateAdd,
                          desRecipe: RecipesReq[index].desRecipe,
                          countPersonRecipe:
                              RecipesReq[index].countPersonRecipe,
                          isShow: RecipesReq[index].isShow,
                          state: '',
                          addByUid: YusrApp.loggedInUser.uid as String,
                          RecipeId: RecipesReq[index].RecipeId),
                      context);
                }
                return Container();
              })),
    );
  }

  showProducts() {
    return Container(
      height: 700,
      width: 390,
      child: SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: ProductReq.length,
              itemBuilder: (BuildContext context, int index) {
                var data = ProductReq[index];
                SizedBox(
                  height: 10,
                );
                if (data.addByUid == YusrApp.loggedInUser.uid) {
                  return buildCardRequestUser(
                      ProductReq[index].dateAdd,
                      ProductReq[index].ProductID,
                      ProductReq[index].state,
                      "product",
                      ProductsRequest(
                          imageProduct: ProductReq[index].imageProduct,
                          callories: ProductReq[index].callories,
                          productType: ProductReq[index].productType,
                          dateAdd: ProductReq[index].dateAdd,
                          state: '',
                          nameProduct: ProductReq[index].nameProduct,
                          addByUid: ProductReq[index].addByUid,
                          isShow: true,
                          ProductID: ProductReq[index].ProductID),
                      context);
                }
                return Container();
              })),
    );
  }
}
