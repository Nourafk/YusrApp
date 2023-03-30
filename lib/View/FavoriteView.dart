import 'package:flutter/material.dart';
import 'package:yusr/Model/ProductModel.dart';
import 'package:yusr/Model/RecipeModel.dart';
import 'package:yusr/Model/StoreModel.dart';
import 'package:yusr/Widget/CardWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controller/YusrApp.dart';

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  initState() {
    getFavRecipesList2();
    getFavProductsList2();
    getFavStoresList2();
  }

  List<Recipe> FavRecipes = [];
  bool noFavRecipesList = false;

  Future getFavRecipesList2() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavRecipes")
        .get();

    setState(() {
      FavRecipes = List.from(data.docs.map((doc) => Recipe.fromMap(doc)));

      if (FavRecipes.length == 0) {
        noFavRecipesList = true;
      }
    });
  }

  List<Product> FavProducts = [];
  bool noFavProductsList = false;

  Future getFavProductsList2() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavProducts")
        .get();

    setState(() {
      FavProducts = List.from(data.docs.map((doc) => Product.fromMap(doc)));

      if (FavProducts.length == 0) {
        noFavProductsList = true;
      }
    });
  }

  List<Store> FavStores = [];
  bool noFavStoresList = false;

  Future getFavStoresList2() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavStores")
        .get();
    if (this.mounted) {
      setState(() {
        FavStores = List.from(data.docs.map((doc) => Store.fromMap(doc)));

        if (FavStores.length == 0) {
          noFavStoresList = true;
        }
      });
    }
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
            "قائمة المفضلة",
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
                                  color: Color(0x4DA7A7A7), width: 1.0),
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
                  height: 10,
                ),
                if (YusrApp.categoryIndex == 0 && noFavStoresList == true)
                  Container(
                    height: 200,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 97),
                            child: Text(
                              'ليس لديك أي متاجر مفضلة',
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
                if (YusrApp.categoryIndex == 0 && noFavStoresList == false)
                  showStores(),
                if (YusrApp.categoryIndex == 1 && noFavProductsList == true)
                  Container(
                    height: 200,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 97),
                          child: Text(
                            'ليس لديك أي منتجات مفضلة',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Tajawal'),
                          ),
                        ),
                      ],
                    )),
                  ),
                if (YusrApp.categoryIndex == 1 && noFavProductsList == false)
                  showProducts(),
                if (YusrApp.categoryIndex == 2 && noFavRecipesList == true)
                  Container(
                      height: 200,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 97),
                              child: Text(
                                'ليس لديك أي وصفات مفضلة',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Tajawal'),
                              ),
                            ),
                          ],
                        ),
                      )),
                if (YusrApp.categoryIndex == 2 && noFavRecipesList == false)
                  showRecipes(),
              ],
            ),
          ),
        ));
  }

  Future removeFromFavourite(id, FavListName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection(FavListName)
        .doc(id)
        .delete()
        .then((value) => print("removed from favourite"));
  }

  showStores() {
    getFavStoresList2();
    return Container(
      height: 500,
      width: 390,
      child: SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: FavStores.length,
              itemBuilder: (BuildContext context, int index) {
                var data = FavStores[index];
                SizedBox(
                  height: 10,
                );
                return buildCard(
                    "store",
                    FavStores[index].StoreID,
                    FavStores[index].StoreName,
                    FavStores[index].StoreLogo,
                    FavStores[index].kilometers,
                    FavStores[index].description,
                    "",
                    "",
                    "",
                    "",
                    FavStores[index].lat,
                    FavStores[index].lng,
                    () {}, () {
                  removeFromFavourite(FavStores[index].StoreID, "FavStores");
                }, context);
              })),
    );
  }

  showProducts() {
    getFavProductsList2();
    return Container(
      height: 500,
      width: 390,
      child: SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: FavProducts.length,
              itemBuilder: (BuildContext context, int index) {
                var data = FavProducts[index];
                SizedBox(
                  height: 20,
                );
                return buildCard(
                    "product",
                    FavProducts[index].ProductID,
                    FavProducts[index].ProductName,
                    FavProducts[index].ProductPhoto,
                    "",
                    "",
                    FavProducts[index].callories,
                    "",
                    "",
                    "",
                    0,
                    0,
                    () {}, () {
                  removeFromFavourite(
                      FavProducts[index].ProductID, "FavProducts");
                }, context);
              })),
    );
  }

  showRecipes() {
    getFavRecipesList2();
    return Container(
      height: 500,
      width: 390,
      child: Column(
        children: [
          Container(
            height: 500,
            width: 390,
            child: SizedBox(
                height: 20,
                child: ListView.builder(
                    itemCount: FavRecipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = FavRecipes[index];
                      SizedBox(
                        height: 20,
                      );
                      return buildCard(
                          "recipie",
                          FavRecipes[index].RecipeID,
                          FavRecipes[index].RecipeName,
                          FavRecipes[index].RecipePhoto,
                          "",
                          FavRecipes[index].description,
                          FavRecipes[index].callories,
                          FavRecipes[index].ingredients,
                          FavRecipes[index].time,
                          FavRecipes[index].persons,
                          0,
                          0,
                          () {}, () {
                        removeFromFavourite(
                            FavRecipes[index].RecipeID, "FavRecipes");
                      }, context);
                    })),
          ),
        ],
      ),
    );
  }
}
