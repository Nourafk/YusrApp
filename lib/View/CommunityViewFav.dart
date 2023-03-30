import 'package:flutter/material.dart';
import 'package:yusr/Model/ProductModel.dart';
import 'package:yusr/Model/RecipeModel.dart';
import 'package:yusr/Model/StoreModel.dart';
import 'package:yusr/Widget/CardWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controller/YusrApp.dart';
import '../Model/UserModel.dart';

class CommunityViewFav extends StatefulWidget {
  final CommunityUser;

  const CommunityViewFav(this.CommunityUser, {super.key});

  @override
  CommunityViewFavState createState() => CommunityViewFavState(CommunityUser);
}

class CommunityViewFavState extends State<CommunityViewFav> {
  UserModel? CommunityUser;

  CommunityViewFavState(CommunityUser) {
    this.CommunityUser = CommunityUser;
  }
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
        .doc(CommunityUser!.uid)
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
        .doc(CommunityUser!.uid)
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
        .doc(CommunityUser!.uid)
        .collection("FavStores")
        .get();

    setState(() {
      FavStores = List.from(data.docs.map((doc) => Store.fromMap(doc)));

      if (FavStores.length == 0) {
        noFavStoresList = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 35,
            ),
          ),
          title: Text(
            "قائمة المفضلة",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Color.fromARGB(255, 44, 44, 44),
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        "المتاجر",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 21, 42, 86),
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            fontFamily: 'Tajawal'),
                      ),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        "المنتجات",
                        style: const TextStyle(
                            color: Color.fromARGB(
                                255, 21, 42, 86), //Colors.orange,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            fontFamily: 'Tajawal'),
                      ),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        "الوصفات",
                        style: const TextStyle(
                            color: Color.fromARGB(
                                255, 21, 42, 86), //Colors.orange,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            fontFamily: 'Tajawal'),
                      ),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              SizedBox(
                height: 20,
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
                            'ليس لديه أي متاجر مفضلة',
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
                          'ليس لديه أي منتجات مفضلة',
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
                              'ليس لديه أي وصفات مفضلة',
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
        ));
  }

  Future removeFromFavourite(id, FavListName) async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(CommunityUser!.uid)
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
                  height: 20,
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
