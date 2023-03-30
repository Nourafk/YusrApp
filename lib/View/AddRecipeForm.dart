import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yusr/Controller/YusrApp.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../main.dart';

class RecipeForm extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<RecipeForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final forCountController = TextEditingController();
  final ingredientsController = TextEditingController();
  final calloriesController = TextEditingController();

  PickedFile? _imageFile;
  bool selectImage = false;
  ImagePicker imagePicker = ImagePicker();
  String nameImage = 'ارفاق صورة';
  List<String> recipeType = [
    "",
    "وجبات رئيسية",
    "وجبات خفيفة",
    "المعكرونة",
    "الحلويات",
    "المخبوزات",
  ];

  String? selectedValue;
  String recipeTypeSelected = "";
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
            'طلب إضافة وصفة',
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
                children: [
                  CustomText("أرفق صورة الوصفة*",
                      color: Color(0x8F909090).withOpacity(0.9),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Tajawal'),
                  SizedBox(
                    width: 45,
                  ),
                  imageProfile()
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
                'اسم الوصفة*',
                "name",
                "text",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                descriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                'طريقة التحضير*',
                "description",
                "text",
                "text"),
            const SizedBox(
              height: 20,
            ),
            ////drop down
            DropdownButtonFormField2(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0XFFd7ab65), width: 1.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0XFFd7ab65), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0x76909090), width: 1.0),
                ),
                prefixIcon: Icon(
                  Icons.list_rounded,
                  size: 25,
                  color: Color(0x8F909090),
                ),
                iconColor: Colors.white,
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                labelText: 'تصنيف الوصفة*',
                labelStyle: TextStyle(
                    color: Color(0x8F909090).withOpacity(0.9),
                    fontFamily: 'Tajawal'),
                hintText: 'إختر تصنيفًا..',
                hintStyle: TextStyle(
                  color: Color(0x8F909090).withOpacity(0.9),
                  fontFamily: 'Tajawal',
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0x8F909090),
              ),
              iconSize: 30,
              buttonHeight: 60,
              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: recipeType
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 21, 42, 86),
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: 'Tajawal')),
                      ))
                  .toList(),
              onChanged: (value) {
                recipeTypeSelected = value!;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                durationController,
                Icon(
                  Icons.timer,
                  color: Color(0x8F909090),
                ),
                'وقت التحضير*',
                "",
                "number",
                'text'),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                forCountController,
                Icon(
                  Icons.person,
                  color: Color(0x8F909090),
                ),
                'عدد الأشخاص*',
                "",
                "number",
                'text'),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                calloriesController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                'السعرات الحرارية*',
                "",
                "number",
                'text'),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                ingredientsController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                'المقادير*',
                "description",
                "text",
                "text"),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    addRecipe(context);
                  },
                  child: Text(
                    admin ? "إضافة" : 'إرسال الطلب',
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
                        return Color(0XFFd7ab65);
                      }),
                      elevation: MaterialStateProperty.all<double>(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color(0XFFd7ab65), width: 1.0),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> addRecipe(BuildContext context) async {
    if (nameController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'اسم الوصفة فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (descriptionController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'وصف الوصفة فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (!selectImage) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'صورة الوصفة فارغة',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (durationController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'وقت التحضير فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (forCountController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'عدد الاشخاص فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (ingredientsController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'حقل المقادير فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (calloriesController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'السعرات الحرارية فارغة',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: Text(
                admin ? "هل تريد إضافة الوصفة؟" : "هل تريد إرسال الطلب؟",
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (admin) {
                        YusrApp().saveAddRecipeAdmin(
                          nameRecipe: nameController.text,
                          desRecipe: descriptionController.text,
                          countPersonRecipe: forCountController.text,
                          ingredientsRecipe: ingredientsController.text,
                          recipesType: recipeTypeSelected,
                          calloriesRecipe: calloriesController.text,
                          timeEndRecipe: durationController.text,
                          nameImage: nameImage,
                          imageRecipe: File(_imageFile!.path),
                        );
                        await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                desc: 'تم اضافة الوصفة بنجاح',
                                btnOkText: 'اغلاق',
                                btnOkOnPress: () {})
                            .show();
                      } else {
                        Future<bool> addState = YusrApp().saveAddRecipe(
                          nameRecipe: nameController.text,
                          recipeType: recipeTypeSelected,
                          desRecipe: descriptionController.text,
                          countPersonRecipe: forCountController.text,
                          ingredientsRecipe: ingredientsController.text,
                          nutritionalInformationRecipe:
                              calloriesController.text,
                          timeEndRecipe: durationController.text,
                          nameImage: nameImage,
                          imageRecipe: File(_imageFile!.path),
                        );
                        await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                desc: 'تم ارسال طلب اضافة الوصفة بنجاح',
                                btnOkText: 'اغلاق',
                                btnOkOnPress: () {})
                            .show();
                      }

                      setState(() {
                        nameImage = '';
                        _imageFile = null;
                        selectImage = false;
                        nameController.clear();
                        descriptionController.clear();
                        forCountController.clear();
                        ingredientsController.clear();
                        calloriesController.clear();
                        durationController.clear();
                      });

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: '',
                                  )),
                          (Route<dynamic> route) => false);
                    },
                    child: Text(
                      admin ? "إضافة" : 'إرسال الطلب',
                      style: TextStyle(
                          color: Color.fromARGB(255, 96, 183, 99),
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
    }
  }

  String? imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future uploadPhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    selectImage = true;
    setState(() {
      _imageFile = pickedFile!;
    });
  }

  Widget imageProfile() {
    return Stack(children: <Widget>[
      chooseImg(),
      Positioned(
          top: 66.0,
          right: 66.0,
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 69, 52, 22),
            radius: 15,
            child: IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 15.0,
              ),
              onPressed: () async {
                uploadPhoto(ImageSource.gallery);
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages =
                    referenceRoot.child('RequestsPics'); //folder

                //Create a reference for the image to be stored
                Reference referenceImageToUpload =
                    referenceDirImages.child('${uniqueFileName}');

                //Handle errors/success
                try {
                  //Store the file
                  await referenceImageToUpload.putFile(File(_imageFile!.path));
                  //Success: get the download URL
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                  nameImage = imageUrl!;
                } catch (error) {
                  //Some error occurred
                  print('an error accurred while uploading image');
                }
              },
            ),
          )),
    ]);
  }

  chooseImg() {
    if (_imageFile == null) {
      return Container(
        height: 95.0,
        width: 95.0,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border.all(color: Color(0x8F909090)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Icon(
          Icons.upload_file_outlined,
          color: Colors.grey,
        ),
      );
    } else {
      return Container(
          height: 95.0,
          width: 95.0,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border.all(color: Color(0x8F909090)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Image.file(File(_imageFile!.path)));
    }
  }
}
