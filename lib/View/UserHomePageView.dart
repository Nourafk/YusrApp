import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Model/StoreModel.dart';
import '../Controller/YusrApp.dart';
import '../Model/ProductModel.dart';
import '../Model/RecipeModel.dart';
import '../Widget/CardWidget.dart';
import '../main.dart';
import 'AddRecipeForm.dart';
import 'ProductForm.dart';
import 'StoresForm.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  User? user = FirebaseAuth.instance.currentUser;

  double pageOffset = 0;
  int PagesIndex = 0;

  List<Store> stores = [];
  bool noStoresList = false;

  Future getStoresList() async {
    var data = await FirebaseFirestore.instance
        .collection('stores')
        .orderBy('kilometers')
        .get();
    if (this.mounted) {
      setState(() {
        stores = List.from(data.docs.map((doc) => Store.fromMap(doc)));

        if (stores.length == 0) {
          noStoresList = true;
        }
      });
    }
  }

  List<Recipe> recipes = [];
  bool noRecipesList = false;

  Future getRecipesList() async {
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

    var data = await FirebaseFirestore.instance
        .collection('recipies')
        .doc('recipe1')
        .collection(col)
        .get();
    if (this.mounted) {
      setState(() {
        recipes = List.from(data.docs.map((doc) => Recipe.fromMap(doc)));

        if (recipes.length == 0) {
          noRecipesList = true;
        }
      });
    }
  }

  List<Product> products = [];
  bool noProductsList = false;

  Future getProductsList() async {
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
    var data = await FirebaseFirestore.instance
        .collection('products')
        .doc('product1')
        .collection(col)
        .get();

    if (this.mounted) {
      setState(() {
        products = List.from(data.docs.map((doc) => Product.fromMap(doc)));
      });
    }
  }

  @override
  void initState() {
    PagesIndex = 0;
    getStoresList();
    getProductsList();
    getRecipesList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 244, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              PagesIndex = 0;
                            });
                          },
                          child: Text(
                            "المتاجر",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 21, 42, 86),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                fontFamily: 'Tajawal'),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white;
                              }
                              return PagesIndex == 0
                                  ? Color.fromARGB(128, 239, 197, 99)
                                  : Colors.white;
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                              PagesIndex = 1;
                            });
                          },
                          child: Text(
                            "المنتجات",
                            style: const TextStyle(
                                color: Color.fromARGB(
                                    255, 21, 42, 86), //Colors.orange,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                fontFamily: 'Tajawal'),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white;
                              }
                              return PagesIndex == 1
                                  ? Color.fromARGB(128, 239, 197, 99)
                                  : Colors.white;
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                              PagesIndex = 2;
                            });
                          },
                          child: Text(
                            "الوصفات",
                            style: const TextStyle(
                                color: Color.fromARGB(
                                    255, 21, 42, 86), //Colors.orange,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                fontFamily: 'Tajawal'),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white;
                              }
                              return PagesIndex == 2
                                  ? Color.fromARGB(128, 239, 197, 99)
                                  : Colors.white;
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Color(0x4DA7A7A7), width: 1.0),
                              ),
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (PagesIndex == 0 && noStoresList == true)
              Container(
                height: 200,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 97),
                        child: Text(
                          "لا يوجد متاجر",
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
            if (PagesIndex == 0 && noStoresList == false) showStores(),
            if (PagesIndex == 1) showProducts(),
            if (PagesIndex == 2) showRecipes(),
          ],
        ),
      ),
    );
  }

  String SearchName = '';
  bool flag = false;
  int count = -1;
  Future addToFavouriteStore(store) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection("FavStores")
        .doc(store.StoreID)
        .set({
      "StoreId": store.StoreID,
      "StoreName": store.StoreName,
      "StoreLogo": store.StoreLogo,
      "kilometers": store.kilometers,
      "lat": store.lat,
      "lng": store.lng,
      "description": store.description,
    }).then((value) => print("Added to favourite"));
  }

  Future removeFromFavouriteStore(store) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection("FavStores")
        .doc(store.StoreID)
        .delete()
        .then((value) => print("removed from favourite"));
  }

  Future addToFavouriteRecipe(recipe) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection("FavRecipes")
        .doc(recipe.RecipeID)
        .set({
      "Category": '',
      "RecipeID": recipe.RecipeID,
      "RecipeName": recipe.RecipeName,
      "RecipePhoto": recipe.RecipePhoto,
      "callories": recipe.callories,
      "description": recipe.description,
      "ingredients": recipe.ingredients,
      "time": recipe.time,
      "persons": recipe.persons
    }).then((value) => print("Added to favourite"));
  }

  Future removeFromFavouriteRecipe(recipe) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection("FavRecipes")
        .doc(recipe.RecipeID)
        .delete()
        .then((value) => print("removed from favourite"));
  }

  Future addToFavouriteProduct(product) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection("FavProducts")
        .doc(product.ProductID)
        .set({
      "ProductID": product.ProductID,
      "ProductName": product.ProductName,
      "ProductPhoto": product.ProductPhoto,
      "callories": product.callories,
    }).then((value) => print("Added to favourite"));
  }

  Future removeFromFavouriteProduct(product) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.uid)
        .collection("FavProducts")
        .doc(product.ProductID)
        .delete()
        .then((value) => print("removed from favourite"));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  showStores() {
    getStoresList();
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 5),
          child: Row(
            children: [
              SizedBox(
                height: 60,
                width: 327,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color(0x76909090), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.orange, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color(0x76909090), width: 1.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'ابحث عن اسم متجر محدد'),
                    onChanged: (val) {
                      setState(() {
                        SearchName = val;
                      });
                    },
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StoresForm()),
                      );
                    },
                    icon: Icon(Icons.add_box_outlined),
                    color: Colors.black,
                    iconSize: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 38, left: 3),
                    child: Text("إضافة متجر",
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Tajawal',
                          color: Color.fromARGB(255, 0, 0, 0),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          width: 390,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: stores.length,
              itemBuilder: (BuildContext context, int index) {
                if (MyHomePageState.currentPosition == null) {
                  return Visibility(
                      visible: false, child: CircularProgressIndicator());
                } else if (MyHomePageState.currentPosition != null) {
                  stores[index].kilometers = calculateDistance(
                          stores[index].lat,
                          stores[index].lng,
                          MyHomePageState.currentPosition?.latitude ?? "",
                          MyHomePageState.currentPosition?.longitude ?? "")
                      .toStringAsFixed(2);

                  // Future<void> writeLocation(String distance, String id) async {
                  //   FirebaseFirestore.instance
                  //       .collection("stores")
                  //       .doc('store$id')
                  //       .update({"kilometers": "$distance"});
                  // }

                  // writeLocation(
                  //     stores[index].kilometers, stores[index].StoreID);
                }
                var data = stores[index];
                if (SearchName.isEmpty) {
                  flag = false;
                  return buildCard(
                      "store",
                      stores[index].StoreID,
                      stores[index].StoreName,
                      stores[index].StoreLogo,
                      stores[index].kilometers,
                      stores[index].description,
                      "",
                      "",
                      "",
                      "",
                      stores[index].lat,
                      stores[index].lng, () {
                    addToFavouriteStore(data);
                  }, () {
                    removeFromFavouriteStore(data);
                  }, context);
                } else if (SearchName.isNotEmpty &&
                    data.StoreName.toString()
                        .toLowerCase()
                        .startsWith(SearchName.toLowerCase())) {
                  flag = true;
                  return buildCard(
                      "store",
                      stores[index].StoreID,
                      stores[index].StoreName,
                      stores[index].StoreLogo,
                      stores[index].kilometers,
                      stores[index].description,
                      "",
                      "",
                      "",
                      "",
                      stores[index].lat,
                      stores[index].lng, () {
                    addToFavouriteStore(data);
                  }, () {
                    removeFromFavouriteStore(data);
                  }, context);
                } else if (flag == false && index == count - 1) {
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
                return Container();
              }),
        )
      ]),
    );
  }

  showRecipes() {
    getRecipesList();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 327,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x76909090), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x76909090), width: 1.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'ابحث عن اسم وصفة محددة'),
                      onChanged: (val) {
                        setState(() {
                          SearchName = val;
                        });
                      },
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipeForm()),
                        );
                      },
                      icon: Icon(Icons.add_box_outlined),
                      color: Colors.black,
                      iconSize: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 38, left: 3),
                      child: Text("إضافة وصفة",
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Tajawal',
                            color: Color.fromARGB(255, 0, 0, 0),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 0;
                      });
                    },
                    child: Text(
                      "وجبات رئيسية",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      "وجبات خفيفة",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        YusrApp.categoryIndex = 2;
                      });
                    },
                    child: Text(
                      "المعكرونة",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        YusrApp.categoryIndex = 3;
                      });
                    },
                    child: Text(
                      "الحلويات",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: 'Tajawal'),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return YusrApp.categoryIndex == 3
                            ? Color.fromARGB(128, 239, 197, 99)
                            : Colors.white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        YusrApp.categoryIndex = 4;
                      });
                    },
                    child: Text(
                      "المخبوزات",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: 'Tajawal'),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return YusrApp.categoryIndex == 4
                            ? Color.fromARGB(128, 239, 197, 99)
                            : Colors.white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                ],
              ),
            ),
          ),
          Container(
              width: 390,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: recipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = recipes[index];
                    if (SearchName.isEmpty) {
                      flag = false;
                      return buildCard(
                          "recipie",
                          recipes[index].RecipeID,
                          recipes[index].RecipeName,
                          recipes[index].RecipePhoto,
                          "",
                          recipes[index].description,
                          recipes[index].callories,
                          recipes[index].ingredients,
                          recipes[index].time,
                          recipes[index].persons,
                          0,
                          0, () {
                        addToFavouriteRecipe(data);
                      }, () {
                        removeFromFavouriteRecipe(data);
                      }, context);
                    } else if (SearchName.isNotEmpty &&
                        data.RecipeName.toString()
                            .toLowerCase()
                            .startsWith(SearchName.toLowerCase())) {
                      flag = true;
                      return buildCard(
                          "recipie",
                          recipes[index].RecipeID,
                          recipes[index].RecipeName,
                          recipes[index].RecipePhoto,
                          "",
                          recipes[index].description,
                          recipes[index].callories,
                          recipes[index].ingredients,
                          recipes[index].time,
                          recipes[index].persons,
                          0,
                          0, () {
                        addToFavouriteRecipe(data);
                      }, () {
                        removeFromFavouriteRecipe(data);
                      }, context);
                    } else if (flag == false && index == count - 1) {
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
                    return Container();
                  })),
        ],
      ),
    );
  }

  showProducts() {
    getProductsList();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 327,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x76909090), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x76909090), width: 1.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'ابحث عن اسم منتج محدد'),
                      onChanged: (val) {
                        setState(() {
                          SearchName = val;
                        });
                      },
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductForm()),
                        );
                      },
                      icon: Icon(Icons.add_box_outlined),
                      color: Colors.black,
                      iconSize: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 38, left: 3),
                      child: Text("إضافة منتج",
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Tajawal',
                            color: Color.fromARGB(255, 0, 0, 0),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // if (pastaLen != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 0;
                      });
                    },
                    child: Text(
                      "المعكرونة",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 21, 42, 86),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color(0x4DA7A7A7), width: 1.0),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  ),
                  // if (snacksLen != 0)
                  SizedBox(
                    width: 10,
                  ),
                  // if (snacksLen != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 1;
                      });
                    },
                    child: Text(
                      "وجبات خفيفة",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color(0x4DA7A7A7), width: 1.0),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  ),
                  // if (sweetsLen != 0)
                  SizedBox(
                    width: 10,
                  ),
                  // if (sweetsLen != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 2;
                      });
                    },
                    child: Text(
                      "الحلويات",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color(0x4DA7A7A7), width: 1.0),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  ),
                  // if (breadLen != 0)
                  SizedBox(
                    width: 10,
                  ),
                  // if (breadLen != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 3;
                      });
                    },
                    child: Text(
                      "المخبوزات",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: 'Tajawal'),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return YusrApp.categoryIndex == 3
                            ? Color.fromARGB(128, 239, 197, 99)
                            : Colors.white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color(0x4DA7A7A7), width: 1.0),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  ),
                  // if (Flour.length != 0)
                  SizedBox(
                    width: 10,
                  ),
                  // if (Flour.length != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        YusrApp.categoryIndex = 4;
                      });
                    },
                    child: Text(
                      "طحين",
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 21, 42, 86), //Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: 'Tajawal'),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return YusrApp.categoryIndex == 4
                            ? Color.fromARGB(128, 239, 197, 99)
                            : Colors.white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                ],
              ),
            ),
          ),
          Container(
              width: 390,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = products[index];

                    if (SearchName.isEmpty) {
                      flag = false;
                      return buildCard(
                          "product",
                          products[index].ProductID,
                          products[index].ProductName,
                          products[index].ProductPhoto,
                          "",
                          "",
                          products[index].callories,
                          "",
                          "",
                          "",
                          0,
                          0, () {
                        addToFavouriteProduct(data);
                      }, () {
                        removeFromFavouriteProduct(data);
                      }, context);
                    } else if (SearchName.isNotEmpty &&
                        data.ProductName.toString()
                            .toLowerCase()
                            .startsWith(SearchName.toLowerCase())) {
                      flag = true;
                      return buildCard(
                          "product",
                          products[index].ProductID,
                          products[index].ProductName,
                          products[index].ProductPhoto,
                          "",
                          "",
                          products[index].callories,
                          "",
                          "",
                          "",
                          0,
                          0, () {
                        addToFavouriteProduct(data);
                      }, () {
                        removeFromFavouriteProduct(data);
                      }, context);
                    } else if (flag == false && index == count - 1) {
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
                    return Container();
                  })),
        ],
      ),
    );
  }
}
