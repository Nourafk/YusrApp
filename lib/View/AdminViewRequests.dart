import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Model/ProductRequest.dart';
import '../Model/RecipeRequest.dart';
import '../Model/StoresRequest.dart';
import '../Widget/CardWidget.dart';

class RequestsPageAdmin extends StatefulWidget {
  const RequestsPageAdmin({super.key});

  @override
  State<RequestsPageAdmin> createState() => _RequestsPageAdminState();
}

class _RequestsPageAdminState extends State<RequestsPageAdmin> {
  String SearchName = '';
  bool flag = false;
  int count = -1;
  int requestsIndex = 0;

  List<RecipesRequest> RecipesReq = [];
  bool noRecipesReqList = false;

  Future getRecipesReqList() async {
    var data = await FirebaseFirestore.instance
        .collection("RecipeRequest")
        .where('state', isEqualTo: '')
        .get();
    if (this.mounted) {
      setState(() {
        RecipesReq =
            List.from(data.docs.map((doc) => RecipesRequest.fromMap(doc)));

        if (RecipesReq.length == 0) {
          noRecipesReqList = true;
        }
      });
    }
  }

  List<ProductsRequest> ProductReq = [];
  bool noProductReqList = false;

  Future getProductReqList() async {
    var data = await FirebaseFirestore.instance
        .collection("ProductRequest")
        .where('state', isEqualTo: '')
        .get();
    if (this.mounted) {
      setState(() {
        ProductReq =
            List.from(data.docs.map((doc) => ProductsRequest.fromMap(doc)));

        if (ProductReq.length == 0) {
          noProductReqList = true;
        }
      });
    }
  }

  List<StoresRequest> StoreReq = [];
  bool noStoreReqList = false;

  Future getStoreReqList() async {
    var data = await FirebaseFirestore.instance
        .collection("StoresRequest")
        .where('state', isEqualTo: '')
        .get();
    if (this.mounted) {
      setState(() {
        StoreReq =
            List.from(data.docs.map((doc) => StoresRequest.fromMap(doc)));

        if (StoreReq.length == 0) {
          noStoreReqList = true;
        }
      });
    }
  }

  updateRequestState(String type) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(type);
    await collectionReference
        .where('state', isEqualTo: "new-approved")
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference.doc(element.id).update({"state": "approved"});
            }));

    await collectionReference
        .where('state', isEqualTo: "new-declined")
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference.doc(element.id).update({"state": "declined"});
            }));
  }

  @override
  void initState() {
    getStoreReqList();
    getProductReqList();
    getRecipesReqList();

    updateRequestState("ProductRequest");
    updateRequestState("RecipeRequest");
    updateRequestState("StoresRequest");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 244, 240),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            requestsIndex = 0;
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
                            return requestsIndex == 0
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
                            requestsIndex = 1;
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
                            return requestsIndex == 1
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
                            requestsIndex = 2;
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
                            return requestsIndex == 2
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (requestsIndex == 0 && noStoreReqList == true)
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
              if (requestsIndex == 0 && noStoreReqList == false) showStores(),
              if (requestsIndex == 1 && noProductReqList == true)
                Container(
                  height: 200,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 97),
                        child: Text(
                          'لا يوجد طلبات إضافة منتج',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Tajawal'),
                        ),
                      ),
                    ],
                  )),
                ),
              if (requestsIndex == 1 && noProductReqList == false)
                showProducts(),
              if (requestsIndex == 2 && noRecipesReqList == true)
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
              if (requestsIndex == 2 && noRecipesReqList == false)
                showRecipes(),
            ],
          ),
        ),
      ),
    );
  }

  showStores() {
    getStoreReqList();
    return Container(
      child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: StoreReq.length,
              itemBuilder: (BuildContext context, int index) {
                var data = StoreReq[index];
                SizedBox(
                  height: 10,
                );

                return buildCardRequest(
                    StoreReq[index].dateAdd,
                    StoreReq[index].StoreID,
                    "store",
                    StoresRequest(
                        imageStore: StoreReq[index].imageStore,
                        desStore: StoreReq[index].desStore,
                        dateAdd: StoreReq[index].dateAdd,
                        state:
                            'منطقة الرياض، 3429 شارع عبدالرحمن بن علي ال الشيخ',
                        nameStore: StoreReq[index].nameStore,
                        addByUid: StoreReq[index].addByUid,
                        isShow: StoreReq[index].isShow,
                        StoreID: StoreReq[index].StoreID),
                    context);
              })),
    );
  }

  showRecipes() {
    getRecipesReqList();
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: RecipesReq.length,
            itemBuilder: (BuildContext context, int index) {
              var data = RecipesReq[index];
              SizedBox(
                height: 10,
              );

              return buildCardRequest(
                  RecipesReq[index].dateAdd,
                  RecipesReq[index].RecipeId,
                  "recipe",
                  RecipesRequest(
                      imageRecipe: RecipesReq[index].imageRecipe,
                      nutritionalInformationRecipe:
                          RecipesReq[index].nutritionalInformationRecipe,
                      ingredientsRecipe: RecipesReq[index].ingredientsRecipe,
                      timeEndRecipe: RecipesReq[index].timeEndRecipe,
                      recipeType: RecipesReq[index].recipeType,
                      nameRecipe: RecipesReq[index].nameRecipe,
                      dateAdd: RecipesReq[index].dateAdd,
                      desRecipe: RecipesReq[index].desRecipe,
                      countPersonRecipe: RecipesReq[index].countPersonRecipe,
                      isShow: RecipesReq[index].isShow,
                      state: '',
                      addByUid: RecipesReq[index].addByUid,
                      RecipeId: RecipesReq[index].RecipeId),
                  context);
            }),
      ),
    );
  }

  showProducts() {
    getProductReqList();
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: ProductReq.length,
            itemBuilder: (BuildContext context, int index) {
              var data = ProductReq[index];
              SizedBox(
                height: 10,
              );

              return buildCardRequest(
                  ProductReq[index].dateAdd,
                  ProductReq[index].ProductID,
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
            }),
      ),
    );
  }
}
