import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/AdminModel.dart';
import '../Model/UserModel.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class YusrApp {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static int categoryIndex = 0;
  static UserModel loggedInUser = UserModel();
  static AdminModel loggedInAdmin = AdminModel();
  User? user = FirebaseAuth.instance.currentUser;
  static String uid = '';
  static int starIndex = 0;

  static var now = new DateTime.now();
  static var formatter = new DateFormat('dd-MM-yyyy');
  String todayDate = formatter.format(now);
  static Random random = new Random();
  String randomNumber = (random.nextInt(900) + 10).toString();

  static UserModel getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    });
    return loggedInUser;
  }

  static AdminModel getCurrentAdmin() {
    final User? user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    FirebaseFirestore.instance
        .collection("admins")
        .doc("admin1")
        .get()
        .then((value) {
      loggedInAdmin = AdminModel.fromMap(value.data());
    });
    return loggedInAdmin;
  }

  Future<bool> saveAddRecipeAdmin({
    required String nameRecipe,
    required String desRecipe,
    required String timeEndRecipe,
    required String countPersonRecipe,
    required String ingredientsRecipe,
    required String recipesType,
    required String calloriesRecipe,
    required String nameImage,
    required File imageRecipe,
  }) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageRecipe);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebaseRecipesID(
          collectionName: 'recipies',
          fieldName: YusrApp.loggedInUser.uid as String,
          recipesType: recipesType,
          data: {
            'RecipeID': randomNumber,
            'RecipeName': nameRecipe,
            'description': desRecipe,
            'time': timeEndRecipe,
            'RecipePhoto': urlImage,
            'persons': countPersonRecipe,
            'ingredients': ingredientsRecipe,
            'callories': calloriesRecipe,
            'Category': ''
          });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveAddRecipe({
    required String nameRecipe,
    required String desRecipe,
    required String timeEndRecipe,
    required String countPersonRecipe,
    required String ingredientsRecipe,
    required String recipeType,
    required String nutritionalInformationRecipe,
    required String nameImage,
    required File imageRecipe,
  }) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageRecipe);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebase(
          collectionName: 'RecipeRequest',
          fieldName: YusrApp.loggedInUser.uid as String,
          data: {
            'nameRecipe': nameRecipe,
            'desRecipe': desRecipe,
            'timeEndRecipe': timeEndRecipe,
            'imageRecipe': urlImage,
            'recipeType': recipeType,
            'countPersonRecipe': countPersonRecipe,
            'ingredientsRecipe': ingredientsRecipe,
            'nutritionalInformationRecipe': nutritionalInformationRecipe,
            'addByUid': user!.uid,
            'isShow': true,
            'state': '',
            'dateAdd': todayDate,
            'RecipeId': randomNumber,
          });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveAddProductAdmin({
    required String nameProduct,
    required String callories,
    required String productType,
    required String nameImage,
    required File imageProduct,
  }) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageProduct);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebaseProductID(
          collectionName: 'products',
          productType: productType,
          fieldName: 'ProductID',
          data: {
            'ProductID': randomNumber,
            'ProductName': nameProduct,
            'ProductPhoto': urlImage,
            'callories': callories,
          });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveAddProduct({
    required String nameProduct,
    required String callories,
    required String productType,
    required String nameImage,
    required File imageProduct,
  }) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageProduct);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebase(
          collectionName: 'ProductRequest',
          fieldName: YusrApp.loggedInUser.uid as String,
          data: {
            'nameProduct': nameProduct,
            'callories': callories,
            'imageProduct': urlImage,
            'productType': productType,
            'addByUid': user!.uid,
            'isShow': true,
            'state': '',
            'dateAdd': todayDate,
            'ProductID': randomNumber,
          });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveAddStoreAdmin({
    required String nameStore,
    required String desStore,
    required String nameImage,
    required num lat,
    required num lng,
    required File imageStore,
  }) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageStore);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebase(
          collectionName: 'stores',
          fieldName: randomNumber as String,
          data: {
            'StoreId': randomNumber,
            'StoreName': nameStore,
            'description': desStore,
            'StoreLogo': urlImage,
            'lat': lat,
            'kilometers': '10',
            'lng': lng,
          });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveAddStore({
    required String nameStore,
    required num lat,
    required num long,
    required String desStore,
    required String nameImage,
    required File imageStore,
  }) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageStore);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebase(
          collectionName: 'StoresRequest',
          fieldName: YusrApp.loggedInUser.uid as String,
          data: {
            'nameStore': nameStore,
            'desStore': desStore,
            'imageStore': urlImage,
            'addByUid': user!.uid,
            'lat': lat,
            'kilometers': '10',
            'lng': long,
            'isShow': true,
            'state': '',
            'dateAdd': todayDate,
            'StoreID': randomNumber,
          });

      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveAddDonation(
      {required String ProductName,
      required String nameImage,
      required File imageFile,
      required String ownerId,
      required String? ownerName,
      required String ExpDate,
      required String? ownerImg}) async {
    String urlImage =
        await uploadFileToStorage(fileName: nameImage, imageFile: imageFile);
    if (urlImage.isNotEmpty) {
      Future<bool> stateAdd = createInFirebaseID(
          collectionName: 'Donation',
          fieldName: 'DonationId',
          data: {
            'DonationId': 'DonationId',
            'ProductName': ProductName,
            'ExpDate': ExpDate,
            'ProductImage': urlImage,
            'ownerId': ownerId,
            'ownerName': ownerName,
            'isShow': true,
            'AddDate': todayDate,
            'isClosed': false,
            'ownerImage': ownerImg,
          });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> closeDonation({required String nameDoc}) async {
    bool state = await updateInFirebase(
        collectionName: 'Donation',
        data: {
          'isShow': false,
          'isClosed': true,
        },
        path: nameDoc);
    if (state) {
      return true;
    } else {
      return false;
    }
  }

  Stream<QuerySnapshot> readStream(
      {required String nameCollection,
      required String orderBy,
      required bool descending}) async* {
    yield* _firebaseFirestore
        .collection(nameCollection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  Future<bool> createInFirebaseID(
      {required String collectionName,
      required String fieldName,
      required Map<String, dynamic>? data}) async {
    return _firebaseFirestore
        .collection(collectionName)
        .add(data!)
        .then((value) async {
      _firebaseFirestore
          .collection(collectionName)
          .doc(value.id)
          .update({fieldName: value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> createInFirebaseProductID(
      {required String collectionName,
      required String productType,
      required String fieldName,
      required Map<String, dynamic>? data}) async {
    String productTypeEN = "";
    if (productType == "المعكرونة")
      productTypeEN = "pasta";
    else if (productType == "المخبوزات")
      productTypeEN = "bread";
    else if (productType == "الحلويات")
      productTypeEN = "sweets";
    else if (productType == "وجبات خفيفة")
      productTypeEN = "snacks";
    else if (productType == "طحين") productTypeEN = "Flour";

    return await _firebaseFirestore
        .collection(collectionName)
        .doc('product1')
        .collection(productTypeEN)
        .add(data!)
        .then((value) async {
      await _firebaseFirestore
          .collection(collectionName)
          .doc('product1')
          .collection(productTypeEN)
          .doc(value.id)
          .update({fieldName: value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> createInFirebaseRecipesID(
      {required String collectionName,
      required String recipesType,
      required String fieldName,
      required Map<String, dynamic>? data}) async {
    String recipesTypeEN = "";
    if (recipesType == "وجبات رئيسية")
      recipesTypeEN = "Essential";
    else if (recipesType == "وجبات خفيفة")
      recipesTypeEN = "snacks";
    else if (recipesType == "المعكرونة")
      recipesTypeEN = "pasta";
    else if (recipesType == "الحلويات")
      recipesTypeEN = "desserts";
    else if (recipesType == "المخبوزات") recipesTypeEN = "bread";

    return await _firebaseFirestore
        .collection(collectionName)
        .doc('recipe1')
        .collection(recipesTypeEN)
        .add(data!)
        .then((value) async {
      await _firebaseFirestore
          .collection(collectionName)
          .doc('recipe1')
          .collection(recipesTypeEN)
          .doc(value.id)
          .update({fieldName: value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> createInFirebase(
      {required String collectionName,
      required String fieldName,
      required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc()
        .set(data!)
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<String> uploadFileToStorage(
      {required File imageFile, required String fileName}) async {
    Reference reference;
    reference = FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowUrl;
  }

  Future<bool> updateInFirebase(
      {required String path,
      required String collectionName,
      required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc(path)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  void sendNotification(
      {required String body, required String fcmToken}) async {
    var headers = {
      'Authorization':
          'Bearer AAAAqjaqeRY:APA91bEbEVFXBino6MNQfROYGWUTGC6Gc6vDfJroduEChc2gnm33WaFS0Bkb0NC6-JjiCjOfFU0rO9KSQzVyFxOczUKX8T6Fu1q5DDHKpkdS9Riol8l8MiNguXCkC5P6wKcZFpRlLw4P',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": "$fcmToken",
      "notification": {"title": "تطبيق يسر", "body": body}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
  }

  updateFCMUser({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var saveUser = FirebaseFirestore.instance.collection('users').doc(id);
    saveUser.update({'fcmToken': prefs.getString('fcmToken')});
  }

  Future<String> getFCMUser({required String id}) async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    return "${user.data()!['fcmToken']}";
  }
}
