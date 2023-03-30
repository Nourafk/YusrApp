import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yusr/Controller/YusrApp.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import 'package:intl/intl.dart';
import '../Widget/CardWidget.dart';
import '../main.dart';

class AddDonation extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<AddDonation> {
  final productController = TextEditingController();
  final dateEndController = TextEditingController();
  PickedFile? _imageFile;
  bool selectImage = false;
  ImagePicker imagePicker = ImagePicker();
  String nameImage = 'ارفاق صورة';
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //ProductNameController.dispose();
    productController.dispose();
    dateEndController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2301));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateEndController.text =
            '${picked.year.toString()}-${picked.month.toString()}-${picked.day.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0XFFd7ab65),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: CustomText('إنشاء تبرع',
                color: Color(0XFFd7ab65),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Tajawal')),
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
                  CustomText("أرفق صورة المنتج*",
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
                productController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                'اسم المنتج*',
                "name",
                "text",
                "text"),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: TextFormField(
                controller: dateEndController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                validator: MultiValidator([
                  RequiredValidator(errorText: 'مطلوب *'),
                ]),
                cursorColor: Color.fromARGB(255, 15, 53, 120),
                style: TextStyle(
                    color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                    fontFamily: 'Tajawal'),

                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0x76909090), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0XFFd7ab65), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0x76909090), width: 1.0),
                    ),
                    labelText: "تاريخ انتهاء الصلاحية*",
                    labelStyle: TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0x8F444444)) //label text of field
                    ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2023, 1, 22, 0, 0), //week from now
                    firstDate: DateTime(2023, 1, 22, 0, 0),
                    lastDate: DateTime(2090, 12, 31, 0, 0),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: TextTheme(
                            headline3: TextStyle(fontFamily: 'Tajawal'),
                            headline4: TextStyle(fontFamily: 'Tajawal'),
                            headline5: TextStyle(
                                fontFamily:
                                    'Tajawal'), // Selected Date landscape
                            headline6: TextStyle(
                                fontFamily:
                                    'Tajawal'), // Selected Date portrait
                            overline: TextStyle(
                                fontFamily: 'Tajawal'), // Title - SELECT DATE
                            bodyText1: TextStyle(
                                fontFamily: 'Tajawal'), // year gridbview picker
                            subtitle1:
                                TextStyle(fontFamily: 'Tajawal'), // input
                            subtitle2: TextStyle(
                                fontFamily: 'Tajawal'), // month/year picker
                            caption: TextStyle(fontFamily: 'Tajawal'),
                          ),
                          colorScheme: ColorScheme.light(
                            primary: Color.fromARGB(
                                255, 230, 203, 67), // <-- SEE HERE
                            onPrimary: Color.fromARGB(
                                255, 121, 103, 49), // <-- SEE HERE
                            onSurface:
                                Color.fromARGB(255, 86, 75, 39), // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                                primary: Color(0xFF393939),
                                textStyle: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontWeight:
                                        FontWeight.w500) // button text color
                                ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      dateEndController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("لم يتم اختيار تاريخ");
                  }
                },
                //--------------------------------------
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () async {
                  print('here');
                  if (productController.text.trim().isEmpty) {
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            desc: 'اسم المنتج فارغ',
                            btnCancelText: 'اغلاق',
                            btnCancelOnPress: () {})
                        .show();
                  } else if (!selectImage) {
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            desc: 'صورة المنتج فارغة',
                            btnCancelText: 'اغلاق',
                            btnCancelOnPress: () {})
                        .show();
                  } else if (dateEndController.text.trim().isEmpty) {
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            desc: 'تاريخ انتهاء المنتج فارغ',
                            btnCancelText: 'اغلاق',
                            btnCancelOnPress: () {})
                        .show();
                  } else {
                    /// upload data here
                    print(user!.uid);
                    Future<bool> addState = YusrApp().saveAddDonation(
                      ProductName: productController.text,
                      nameImage:
                          DateTime.now().microsecondsSinceEpoch.toString(),
                      imageFile: File(_imageFile!.path),
                      ownerId: user!.uid,
                      ownerName: YusrApp.loggedInUser.name,
                      ExpDate: dateEndController.text,
                      ownerImg: YusrApp.loggedInUser.imagePath,
                    );

                    await showConfirmation(
                        'تم اضافة التبرع بنجاح', 'اغلاق', context, '');

                    setState(() {
                      nameImage = '';
                      productController.clear();
                      _imageFile = null;
                      dateEndController.clear();
                      selectImage = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: '',
                                )),
                        (Route<dynamic> route) => false);
                  }
                },
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
                child: Text(
                  'إنشاء تبرع',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Tajawal'),
                ),
              ),
            )
          ],
        ),
      );

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
