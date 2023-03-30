import 'package:flutter/material.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';

import '../Model/RecipeRequest.dart';

class RecipeRequest extends StatefulWidget {
  final recipe;
  RecipeRequest(this.recipe, {super.key});
  @override
  State<RecipeRequest> createState() => _TextfieldGeneralWidgetState(recipe);
}

class _TextfieldGeneralWidgetState extends State<RecipeRequest> {
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

  @override
  void initState() {
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.001,
                  20,
                  MediaQuery.of(context).size.height * 0.001),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      );
}
