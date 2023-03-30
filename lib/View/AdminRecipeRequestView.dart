import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../Model/RecipeRequest.dart';
import '../Widget/CardWidget.dart';

class AdminRecipeRequestView extends StatefulWidget {
  final recipe;
  AdminRecipeRequestView(this.recipe, {super.key});
  @override
  State<AdminRecipeRequestView> createState() =>
      _TextfieldGeneralWidgetState(recipe);
}

class _TextfieldGeneralWidgetState extends State<AdminRecipeRequestView> {
  RecipesRequest? recipe;
  _TextfieldGeneralWidgetState(recipe) {
    this.recipe = recipe;
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final forCountController = TextEditingController();
  final ingredientsController = TextEditingController();
  final calloriesController = TextEditingController();

  String name = "";
  String fcmToken = "";

  @override
  void initState() {
    setName();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    forCountController.dispose();
    ingredientsController.dispose();
    calloriesController.dispose();
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
              'رقم الطلب:' + " ${recipe!.RecipeId}",
              style: TextStyle(
                  color: Color(0XFF81663C),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
            Text(
              'تاريخ الاضافة:' + " ${recipe!.dateAdd}",
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
                  CustomText("      صورة الوصفة",
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
                          image: NetworkImage(recipe!.imageRecipe),
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
                nameController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                recipe!.nameRecipe,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                descriptionController,
                Icon(
                  Icons.soup_kitchen,
                  color: Color(0x8F909090),
                ),
                recipe!.desRecipe,
                "description",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                calloriesController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                recipe!.nutritionalInformationRecipe + ' cal',
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                durationController,
                Icon(
                  Icons.timer,
                  color: Color(0x8F909090),
                ),
                recipe!.timeEndRecipe,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                durationController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                recipe!.recipeType,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                forCountController,
                Icon(
                  Icons.person,
                  color: Color(0x8F909090),
                ),
                recipe!.countPersonRecipe + ' أشخاص',
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                ingredientsController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                recipe!.ingredientsRecipe,
                "description",
                "request",
                "text"),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 0, 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        await AddRecipeApproval(recipe: recipe!).whenComplete(
                          () {
                            showConfirmation('تمت إضافة الوصفة بنجاح ', 'إغلاق',
                                context, '');
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
                        await declineRecipe(recipe!);
                        showConfirmation(
                            'تم رفض طلب إضافةالوصفة ', 'إغلاق', context, '');
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
        .where('uid', isEqualTo: "${recipe!.addByUid}")
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

  //----------------------------------------------------------------------------
  Future AddRecipeApproval({required RecipesRequest recipe}) async {
    //String uniqueId = UniqueKey().toString();
    String enType = '';
    if (recipe.recipeType == 'وجبات رئيسية') enType = 'Essential';
    if (recipe.recipeType == 'وجبات خفيفة') enType = 'snacks';
    if (recipe.recipeType == 'المعكرونة') enType = 'pasta';
    if (recipe.recipeType == 'الحلويات') enType = 'desserts';
    if (recipe.recipeType == 'المخبوزات') enType = 'bread';

    await FirebaseFirestore.instance
        .collection("recipies")
        .doc('recipe1')
        .collection(enType)
        .doc(recipe.RecipeId)
        .set({
      'RecipeID': recipe.RecipeId,
      'RecipeName': recipe.nameRecipe,
      'RecipePhoto': recipe.imageRecipe,
      'description': recipe.desRecipe,
      'callories': recipe.nutritionalInformationRecipe,
      'ingredients': recipe.ingredientsRecipe,
      'time': recipe.timeEndRecipe,
      'persons': recipe.countPersonRecipe,
    });
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('RecipeRequest');

    await collectionReference
        .where('RecipeId', isEqualTo: recipe.RecipeId)
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference
                  .doc(element.id)
                  .update({"state": "new-approved"});
            }));
  }

  Future declineRecipe(RecipesRequest recipe) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('RecipeRequest');

    await collectionReference
        .where('RecipeId', isEqualTo: recipe.RecipeId)
        .get()
        .then((value) => value.docs.forEach((element) {
              collectionReference
                  .doc(element.id)
                  .update({"state": "new-declined"});
            }));
  }
}
