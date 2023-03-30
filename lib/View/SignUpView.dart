import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'LoginPageView.dart';
import 'package:intl/intl.dart';
import '../Model/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Gender { Male, Female }

class _RegisterPageState extends State<RegisterPage> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final phonenumberController = TextEditingController();
  final dateofbirthController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final numericRegex = RegExp(r'[0-9]');
  final CharRegex = RegExp(r'[!@#\$&*~]');
  final LetterRegex = RegExp(r'[a-z A-Z]');

  late bool isUsed;

  final _auth = FirebaseAuth.instance;
  var _instance = FirebaseFirestore.instance;

  String errorMsg = '';
  bool isLoading = false;
  Gender gender = Gender.Male; //-----------------------------------#
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Image.asset(
            "assets/yusrRegister.png",
            fit: BoxFit.fill,
          ),
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
                      controller: firstnameController,
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
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: validateEmail,
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
                          fillColor: Colors.white.withOpacity(0.9),
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
                      controller: _usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: validateUsername,
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
                    // reusableTextField("Enter your password", true, _passController),
                    TextFormField(
                      maxLength: 15,
                      obscureText: true,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _passController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validatePassword,
                      cursorColor: Color.fromARGB(255, 15, 53, 120),
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                          fontFamily: 'Tajawal'),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? Icon(
                                    Icons.visibility,
                                    color: Color.fromARGB(255, 15, 53, 120),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(255, 15, 53, 120),
                                  ),
                          ),
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
                            Icons.lock,
                            color: Color(0x8F909090),
                          ),
                          iconColor: Colors.white,
                          labelText: "كلمة المرور*",
                          labelStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          counterText: ""),
                      //keyboardType: TextInputType.emailAddress,
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
                                        255, 230, 203, 67), // <-- SEE HERE
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
                    // Row(children: [
                    //   SizedBox(
                    //     height: 40,
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: const Text(
                    //       "الجنس : ",
                    //       style: TextStyle(
                    //           color: Color.fromARGB(255, 106, 106, 106),
                    //           fontFamily: 'Tajawal'),
                    //     ),
                    //   ),
                    // ]),
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
                          width: 50,
                        ),
                        Radio<Gender>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Color(0XFFd7ab65)),
                          focusColor: MaterialStateColor.resolveWith(
                              (states) => Color(0XFFd7ab65)),
                          value: Gender.Male,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            if (value != null) {
                              setState(() {
                                gender = value;
                              });
                            }
                          },
                        ),
                        const Text('ذكر '),
                        SizedBox(
                          width: 30,
                        ),
                        Radio<Gender>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Color(0XFFd7ab65)),
                          focusColor: MaterialStateColor.resolveWith(
                              (states) => Color(0XFFd7ab65)),
                          value: Gender.Female,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            if (value != null) {
                              setState(() {
                                gender = value;
                              });
                            }
                          },
                        ),
                        const Text('أنثى '),
                      ],
                    ),

                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          :
                          //ReusableButton('تسجيل', signupOnPressed())
                          SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  isUsed = await userExists(
                                      _usernameController.text.trim());
                                  if (!isUsed)
                                    register(_emailController.text.trim(),
                                        _passController.text);
                                  else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              content: Text(
                                                  'المعرّف غير متاح, مستخدم مسبقاً'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'حسنًا'),
                                                  child: const Text('حسنًا'),
                                                )
                                              ]);
                                        });
                                  }
                                },
                                child: Text(
                                  'تسجيل',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'Tajawal'),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.grey;
                                      }
                                      return Color(0XFFd7ab65);
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)))),
                              ),
                            ),
                    ),

                    Registered(context)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------------------------------//
  Row Registered(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
        ),
        const Text(
          "لديك حساب بالفعل؟ ",
          style: TextStyle(
              color: Color.fromARGB(255, 106, 106, 106), fontFamily: 'Tajawal'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          },
          child: const Text(
            "تسجيل دخول",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 15, 53, 120),
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal'),
          ),
        )
      ],
    );
  }

  Future signupOnPressed() async {
    register(_emailController.text.trim(), _passController.text);
  }

  Future signup() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passController.text)
          .then((value) => Navigator.pop(
              context, MaterialPageRoute(builder: (context) => LoginPage())));
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text('تم إنشاء الحساب بنجاح'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
                    child: const Text('حسنًا'),
                  )
                ]);
          });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(e.message.toString()), actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'حسنًا'),
                child: const Text('حسنًا'),
              )
            ]);
          });
    }
  }

  void register(String email, String password) async {
    if (_key.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()});
      } on FirebaseAuthException catch (e) {
        print(e);
        Map<String, String?> codeResponses = {
          // Re-auth responses
          "user-mismatch": 'المستخدم غير متطابق',
          "user-not-found": 'لم يتم العثور على المستخدم',
          "invalid-credential": 'invalid credential',
          "invalid-email": 'الايميل غير موجود',
          "wrong-password": 'كلمة المرور الحالية خاطئة',
          "invalid-verification-code": 'رمز التحقق غير صالح',
          "invalid-verification-id": 'معرّف التحقق غير صالح',
          "user-disabled": 'المستخدم لهذا الايميل معطّل',
          "too-many-requests": 'طلبات كثيرة',
          "operation-not-allowed":
              'تسجيل الدخول من خلال الايميل وكلمة المرور غير مسموح',
          // Update password error codes
          "weak-password": 'كلمة المرور غير قوية',
          "requires-recent-login": 'يتطلب تسجيل دخول حديث'
        };
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: Text(codeResponses[e.code]!),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'حسنًا'),
                      child: const Text('حسنًا'),
                    )
                  ]);
            });
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(name: firstnameController.text);

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = firstnameController.text;
    userModel.imagePath = imageUrl;
    userModel.username = _usernameController.text;
    userModel.phonenumber = phonenumberController.text;
    userModel.dateofbirth = dateofbirthController.text;
    userModel.gender = gender.toString();
    userModel.points = 0;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(
      msg: "تم إنشاء حسابك بنجاح",
      backgroundColor: Color.fromARGB(187, 39, 38, 29),
    );
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty)
      return 'البريد الالكتروني مطلوب';

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'صيغة البريد الالكتروني غير صحيحة';

    return null;
  }

  Future<bool> userExists(String username) async => (await _instance
      .collection("users")
      .where("username", isEqualTo: username)
      .get()
      .then((value) => value.size > 0 ? true : false));

  String? validateUsername(String? username) {
    String boolvalue = userExists(username!).toString();
    if (boolvalue == 'true') {
      isUsed = true;
    } else {
      isUsed = false;
    }

    final nameRegex =
        RegExp(r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');

    if (username == null || username.isEmpty)
      return '* مطلوب';
    else if (username.length < 2)
      return 'يجب أن لايقل عن حرفين';
    else if (username.length > 20)
      return 'يجب أن لايتجاوز 20 حرف';
    else if (!nameRegex.hasMatch(username))
      return '  يجب أن يبدأ وينتهي بحرف انجليزي أو رقم';
    else if (isUsed)
      return ' المعرّف موجود, قد تم استخدامه من قبل';
    else
      return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty)
      return 'كلمة المرور مطلوبة';
    else if (formPassword.length < 8)
      return 'يجب ان تحتوي كلمة السر على 8 خانات أو أكثر';
    else if (!numericRegex.hasMatch(formPassword))
      return 'يجب أن تحتوي كلمة السر على رقم واحد على الاقل';
    else if (!CharRegex.hasMatch(formPassword))
      return 'يجب أن تحتوي كلمة السر على رمز خاص واحد على الاقل';
    else if (!LetterRegex.hasMatch(formPassword))
      return 'يجب أن تحتوي كلمة السر على حرف واحد على الاقل';
    else
      return null;
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "اختر صورة العرض",
            style: TextStyle(
              fontSize: 20.0,
              color: Color.fromARGB(255, 30, 30, 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            // FlatButton.icon(
            //   icon: Icon(Icons.camera),
            //   onPressed: () {
            //     takePhoto(ImageSource.camera);
            //   },
            //   label: Text("Camera"),
            // ),
            TextButton.icon(
              icon: Icon(
                Icons.image,
                color: Color.fromARGB(255, 30, 30, 30),
              ),
              onPressed: () async {
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
                } catch (error) {
                  //Some error occurred
                  print('an error accurred while uploading image');
                }
              },
              label: Text("البوم الكاميرا",
                  style: TextStyle(
                      color: Color.fromARGB(255, 30, 30, 30), fontSize: 17.0)),
            ),
          ])
        ],
      ),
    );
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
              ? AssetImage("assets/profile.png") as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 7.0,
          right: 70.0,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromARGB(255, 27, 30, 62),
            child: IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 15.0,
              ),
              onPressed: () async {
                uploadPhoto(ImageSource.gallery);
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
