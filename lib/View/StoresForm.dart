import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yusr/Controller/YusrApp.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../main.dart';
import 'mapPage.dart';

class StoresForm extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<StoresForm> {
  final storeController = TextEditingController();
  final storeDescriptionController = TextEditingController();
  String nameLocation = '';
  double lat = 0.0;
  double long = 0.0;

  PickedFile? _imageFile;
  bool selectImage = false;
  ImagePicker imagePicker = ImagePicker();
  String nameImage = 'ارفاق صورة';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    storeController.dispose();
    storeDescriptionController.dispose();
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
            'طلب إضافة متجر',
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
                  CustomText("أرفق صورة المتجر*",
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
                storeController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                'اسم المتجر*',
                "name",
                "text",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                storeDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                'وصف المتجر*',
                "description",
                "text",
                "text"),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0x76909090))),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  ).then((value) {
                    if (value != null) {
                      value as List<dynamic>;
                      print(value);
                      setState(() {
                        lat = value[0];
                        long = value[1];
                        nameLocation = value[2];
                      });
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: CustomText(
                      nameLocation,
                      color: Colors.grey,
                      maxLines: 1,
                    )),
                    Icon(
                      Icons.location_on,
                      color: Color.fromRGBO(215, 171, 101, 1),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    addStore(context);
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

  Future<void> addStore(BuildContext context) async {
    if (storeController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'اسم المتجر فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (storeDescriptionController.text.trim().isEmpty) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'وصف المتجر فارغ',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (!selectImage) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'صورة المتجر فارغة',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else if (lat == 0.0 && long == 0.0) {
      await AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              desc: 'موقع المتجر اجباري',
              btnCancelText: 'اغلاق',
              btnCancelOnPress: () {})
          .show();
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: Text(
                admin ? "هل تريد إضافة المتجر؟" : "هل تريد إرسال الطلب؟",
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (admin) {
                        YusrApp().saveAddStoreAdmin(
                          nameStore: storeController.text,
                          desStore: storeDescriptionController.text,
                          nameImage: nameImage,
                          lat: lat,
                          lng: long,
                          imageStore: File(_imageFile!.path),
                        );
                        await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                desc: 'تم اضافة المتجر بنجاح',
                                btnOkText: 'اغلاق',
                                btnOkOnPress: () {})
                            .show();
                      } else {
                        YusrApp().saveAddStore(
                          lat: lat,
                          long: long,
                          nameStore: storeController.text,
                          desStore: storeDescriptionController.text,
                          nameImage: nameImage,
                          imageStore: File(_imageFile!.path),
                        );
                        await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                desc: 'تم ارسال طلب اضافة المتجر بنجاح',
                                btnOkText: 'اغلاق',
                                btnOkOnPress: () {})
                            .show();
                      }

                      setState(() {
                        nameImage = '';
                        storeController.clear();
                        _imageFile = null;
                        storeDescriptionController.clear();
                        selectImage = false;
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
