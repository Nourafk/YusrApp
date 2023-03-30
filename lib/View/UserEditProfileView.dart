import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:yusr/Model/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yusr/Controller/YusrApp.dart';
import 'package:yusr/View/SignUpView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show MaxLengthEnforcement, rootBundle;
import 'package:yusr/main.dart';
import 'ChangePassView.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phonenumberController = TextEditingController();
  final dateofbirthController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  PickedFile? _imageFile;
  String? imageUrl;
  String? userphoto = YusrApp.loggedInUser.imagePath; //.imageUrl;
  Gender gender = Gender.Male;
  String errorMsg = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        YusrApp.loggedInUser = UserModel.fromMap(value.data());
      });
    });
    fullnameController.text = YusrApp.loggedInUser.name!;
    usernameController.text = YusrApp.loggedInUser.username!;
    emailController.text = YusrApp.loggedInUser.email!;
    phonenumberController.text = YusrApp.loggedInUser.phonenumber!;
    dateofbirthController.text = YusrApp.loggedInUser.dateofbirth!;
    userphoto = YusrApp.loggedInUser.imagePath!;
    // _imageFile = user.imagePath! as PickedFile?;
    if (YusrApp.loggedInUser.gender == 'Gender.Female') {
      gender = Gender.Female;
    } else if (YusrApp.loggedInUser.gender == 'Gender.Male') {
      gender = Gender.Male;
    }
  }

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
          'تعديل الحساب',
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
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          imageProfile(),
          const SizedBox(
            height: 20,
          ),
          Form(
            //key: _key,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).size.height * 0.001,
                    20,
                    MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: fullnameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateName,
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                          fontFamily: 'Tajawal'),

                      decoration: InputDecoration(
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
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0x8F909090),
                          ),
                          iconColor: Colors.white,
                          labelText: "الاسم الكامل*",
                          labelStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          counterText: ""
                          // border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(30.0),),
                          ),

                      keyboardType: TextInputType.name,
                      //--------------------------------------
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //email field
                    TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: false,

                      //validator: validateEmail,
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                          fontFamily: 'Tajawal'),

                      decoration: InputDecoration(
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
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0x8F909090),
                          ),
                          iconColor: Colors.white,
                          labelText: "البريد الالكتروني*",
                          labelStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          hintText: 'email@address.com',
                          hintStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          fillColor: Color.fromARGB(54, 184, 183, 183),
                          counterText: ""
                          // border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(30.0),),
                          ),

                      keyboardType: TextInputType.emailAddress,
                      //--------------------------------------
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //Username
                    TextFormField(
                      controller: usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: false,
                      //validator: validateUsername,
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                          fontFamily: 'Tajawal'),

                      decoration: InputDecoration(
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
                          prefixIcon: Icon(
                            Icons.fingerprint,
                            color: Color(0x8F909090),
                          ),
                          iconColor: Colors.white,
                          labelText: "معرّف الحساب*",
                          labelStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          hintText: '@username',
                          hintStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          fillColor: Color.fromARGB(54, 184, 183, 183),
                          counterText: ""
                          // border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(30.0),),
                          ),

                      keyboardType: TextInputType.name,
                      //--------------------------------------
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //----Phone Number Field----
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: phonenumberController,
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,

                      validator: MultiValidator([
                        RequiredValidator(errorText: 'مطلوب *'),
                        PatternValidator(r'^(05)([0-9]{8})$',
                            errorText: 'أدخل رقم هاتف صالح')
                      ]),
                      cursorColor: Color.fromARGB(255, 15, 53, 120),
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                          fontFamily: 'Tajawal'),

                      decoration: InputDecoration(
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
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0x8F909090),
                          ),
                          iconColor: Colors.white,
                          labelText: "رقم الهاتف*",
                          labelStyle: TextStyle(
                              color: Color(0x76909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          hintText: '05XXXXXXXX',
                          hintStyle: TextStyle(
                              color: Color(0x76909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          counterText: ""),

                      keyboardType: TextInputType.phone,
                      //--------------------------------------
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //-------birthday field----------
                    GestureDetector(
                      child: TextFormField(
                        controller: dateofbirthController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: MultiValidator([
                          RequiredValidator(errorText: 'مطلوب *'),
                        ]),
                        cursorColor: Color.fromARGB(255, 15, 53, 120),
                        style: TextStyle(
                            color: Color.fromARGB(255, 15, 53, 120)
                                .withOpacity(0.9),
                            fontFamily: 'Tajawal'),

                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
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
                            labelText: "تاريخ الميلاد*",
                            labelStyle: TextStyle(
                                fontFamily: 'Tajawal',
                                color: Color(0x8F444444)) //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2012, 12, 31, 0, 0),
                            firstDate: DateTime(1930),
                            lastDate: DateTime(2012, 12, 31, 0, 0),
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
                                        fontFamily:
                                            'Tajawal'), // Title - SELECT DATE
                                    bodyText1: TextStyle(
                                        fontFamily:
                                            'Tajawal'), // year gridbview picker
                                    subtitle1: TextStyle(
                                        fontFamily: 'Tajawal'), // input
                                    subtitle2: TextStyle(
                                        fontFamily:
                                            'Tajawal'), // month/year picker
                                    caption: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                  colorScheme: ColorScheme.light(
                                    primary: Color.fromARGB(
                                        255, 228, 211, 123), // <-- SEE HERE
                                    onPrimary: Color.fromARGB(
                                        255, 121, 103, 49), // <-- SEE HERE
                                    onSurface: Color.fromARGB(
                                        255, 86, 75, 39), // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                        primary: Color(0xFF393939),
                                        textStyle: TextStyle(
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight
                                                .w500) // button text color
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
                              dateofbirthController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("لم يتم اختيار تاريخ");
                          }
                        },
                        //--------------------------------------
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '   الجنس* :  ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 106, 106, 106),
                              fontSize: 18,
                              fontFamily: 'Tajawal'),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Radio<Gender>(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 184, 183, 183),
                          ),
                          focusColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(54, 184, 183, 183),
                          ),
                          value: Gender.Male,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            if (value != null) {
                              setState(() {
                                // gender = value;
                              });
                            }
                          },
                        ),
                        const Text('ذكر ',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Tajawal',
                              color: Color.fromARGB(255, 106, 106, 106),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        Radio<Gender>(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 184, 183, 183),
                          ),
                          focusColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(54, 184, 183, 183),
                          ),
                          value: Gender.Female,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            if (value != null) {
                              setState(() {
                                // gender = value;
                              });
                            }
                          },
                        ),
                        const Text('أنثى ',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Tajawal',
                              color: Color.fromARGB(255, 106, 106, 106),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    checkNull();
                    checkValid();
                    if (name == false &&
                        phone == false &&
                        date == false &&
                        image == false) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: Text('لم تجري أي تعديلات!',
                                  style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing: 0.8,
                                      fontFamily: 'Tajawal')),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("حسنّا",
                                        style:
                                            TextStyle(fontFamily: 'Tajawal')))
                              ],
                            );
                          }));
                    } else if (isFnameValid! && isPhoneValid!) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: Text("هل تريد حفظ التعديلات؟"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      isChanged = false;
                                      saveChanges();

                                      await AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.bottomSlide,
                                              desc: "تم حفظ التغييرات بنجاح",
                                              btnOkText: 'اغلاق',
                                              btnOkOnPress: () {})
                                          .show();
                                      Navigator.pop(context);
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => MyHomePage(
                                                    title: '',
                                                  )),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text(
                                      "نعم",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 96, 183, 99),
                                          fontFamily: 'Tajawal'),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("إلغاء",
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                        )))
                              ],
                            );
                          }));
                    }
                  },
                  child: Text(
                    'حفظ التعديلات',
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
          ),
          const SizedBox(height: 5),
          Center(
            //padding: EdgeInsets.only(top: 15.0, right: 90.0),
            child: SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePass(),
                      ));
                },
                child: Text(
                  'تغيير كلمة المرور',
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
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  bool? name;
  bool? phone;
  bool? date;
  bool image = false;
  bool isChanged = false;

  checkNull() {
    fullnameController.text == YusrApp.loggedInUser.name
        ? name = false
        : name = true;
    phonenumberController.text == YusrApp.loggedInUser.phonenumber
        ? phone = false
        : phone = true;
    dateofbirthController.text == YusrApp.loggedInUser.dateofbirth
        ? date = false
        : date = true;
    isChanged ? image = true : image = false;
  }

  bool? isFnameValid;
  bool? isPhoneValid;

  checkValid() {
    final phoneRegExp = RegExp(r'^(05)([0-9]{8})$');
    final nameRegExp = RegExp(
        r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z\u0600-\u06ff ]{3,30}$');

    isFnameValid = nameRegExp.hasMatch(fullnameController.text);
    isPhoneValid = phoneRegExp.hasMatch(phonenumberController.text);
  }

  saveChanges() {
    var saveUser = FirebaseFirestore.instance
        .collection('users')
        .doc(YusrApp.loggedInUser.uid);

    if (fullnameController.text.isNotEmpty) {
      name = true;
      saveUser.update({'name': fullnameController.text});
    }
    if (phonenumberController.text.isNotEmpty) {
      phone = true;
      saveUser.update({'phonenumber': phonenumberController.text});
    }

    if (dateofbirthController.text.isNotEmpty) {
      date = true;
      saveUser.update({'dateofbirth': dateofbirthController.text});
    }

    UserModel newUserData = YusrApp.getCurrentUser();
  }

  String? validateName(String? formName) {
    final nameRegex = RegExp(
        r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z\u0600-\u06ff ]{3,30}$');

    if (formName == null || formName.isEmpty)
      return 'الاسم مطلوب';
    else if (formName.length < 3)
      return 'يجب أن يتكون الاسم من 3 أحرف فأكثر';
    else if (formName.length > 30)
      return 'يجب أن لا يتجاوز الاسم 30 حرف ';
    else if (!nameRegex.hasMatch(formName))
      return ' لا بجب أن يحتوي على أرقام ورموز';
    else
      return null;
  }

  Future uploadPhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    setState(() {
      _imageFile = pickedFile!;
    });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 50.0,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          backgroundImage: _imageFile == null
              ? NetworkImage(YusrApp.loggedInUser.imagePath!) as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 7.0,
          right: 70.0,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromARGB(255, 69, 52, 22),
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 15.0,
              ),
              onPressed: () async {
                isChanged = true;
                //image = true;
                await uploadPhoto(ImageSource.gallery);
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages =
                    referenceRoot.child('profilePics'); //folder

                //Create a reference for the image to be stored
                Reference referenceImageToUpload =
                    referenceDirImages.child('${uniqueFileName}');

                //Handle errors/success
                try {
                  //Store the file
                  await referenceImageToUpload.putFile(File(_imageFile!.path));

                  //Success: get the download URL
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(YusrApp.loggedInUser.uid)
                      .update({'imagePath': imageUrl});
                  // image = true;
                  // isChanged = true;
                  UserModel newUserData = YusrApp.getCurrentUser();
                  YusrApp.loggedInUser.copy(imagePath: imageUrl);
                } catch (error) {
                  //Some error occurred
                  print('an error accurred while uploading image');
                }
              },
            ),
          ),
        ),
      ]),
    );
  }
}
