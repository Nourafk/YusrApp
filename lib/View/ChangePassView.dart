import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yusr/View/UserHomePageView.dart';

class UpdatePass extends StatefulWidget {
  const UpdatePass({Key? key}) : super(key: key);

  @override
  _UpdatePassState createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final RepeatPasswordController = TextEditingController();

  final emailController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String errorMsg = '';
  bool isLoading = false;

  static var _firestore;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
  }

  String? validatePassword(String? formPassword) {
    final numericRegex = RegExp(r'[0-9]'); //{1,10}$
    final CharRegex = RegExp(r'[!@#\$&*~]');
    final LetterRegex = RegExp(r'[a-z A-Z]');

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

  String CurrentUser = "";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 244, 240),
      resizeToAvoidBottomInset: false,
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
          "تحديث كلمة المرور",
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
        children: [
          SizedBox(
            height: 30,
          ),
          Form(
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
                    //current field
                    TextFormField(
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: currentPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: MultiValidator([
                        RequiredValidator(errorText: 'مطلوب *'),
                        // PatternValidator(
                        //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                        //     errorText: 'كلمة مرور الحالية خاطئة'),
                      ]),
                      obscureText: isVisible,
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(fontSize: 20, color: Colors.black),

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
                                    color: Color.fromARGB(255, 32, 38, 47),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(255, 32, 38, 47),
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
                          labelText: " كلمة المرور الحالية*",
                          labelStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          counterText: ""),

                      keyboardType: TextInputType.visiblePassword,
                      //--------------------------------------
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    //----New password Field----
                    TextFormField(
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: newPasswordController,

                      validator: validatePassword,

                      obscureText: isVisible,
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(fontSize: 20, color: Colors.black),

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
                                    color: Color.fromARGB(255, 32, 38, 47),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(255, 32, 38, 47),
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
                          labelText: " كلمة المرور الجديدة*",
                          labelStyle: TextStyle(
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          counterText: ""),

                      keyboardType: TextInputType.visiblePassword,
                      //--------------------------------------
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: RepeatPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: (validator) {
                        RequiredValidator(errorText: '* مطلوب');

                        if (validator != newPasswordController.text)
                          return 'تأكيد كلمة المرور غير متطابق';
                        return null;
                      },

                      obscureText: true,
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(fontSize: 20, color: Colors.black),

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
                                    color: Color.fromARGB(255, 32, 38, 47),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(255, 32, 38, 47),
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
                          labelText: " تأكيد كلمة المرور الجديدة*",
                          labelStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0x8F909090).withOpacity(0.9),
                              fontFamily: 'Tajawal'),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          counterText: ""),
                      keyboardType: TextInputType.visiblePassword,
                      //--------------------------------------
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    bool confirmed = ConfirmationResult(
                        newPasswordController.text,
                        RepeatPasswordController.text);
                    bool changed = !noChange(currentPasswordController.text,
                        newPasswordController.text);

                    final String? trySavePassChange = await saveChanges(
                        currentPasswordController.text,
                        newPasswordController.text);
                    if (isValidNewPass && changed && confirmed) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: Text("هل أنت متأكد من تغيير كلمة المرور؟"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      if (trySavePassChange == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Color.fromARGB(
                                              255, 135, 155, 190),
                                          content: Text(
                                              "تم تغيير كلمة مرورك بنجاح",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  letterSpacing: 0.8,
                                                  fontFamily: 'Tajawal')),
                                          action: null,
                                        ));
                                        //EcommerceApp.pageIndex = 4;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageUser(),
                                            ));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageUser(),
                                            ));
                                      } // end if-------------------------------
                                      else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          duration: const Duration(seconds: 2),
                                          backgroundColor:
                                              Color.fromARGB(255, 227, 186, 73),
                                          content: Text(
                                              'تعذّر تحديث كلمة المرور,' +
                                                  trySavePassChange.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  letterSpacing: 0.8,
                                                  fontFamily: 'Tajawal')),
                                          action: null,
                                        ));
                                      }
                                    },
                                    child: Text(
                                      "نعم",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontFamily: 'Tajawal'),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("إلغاء"))
                              ],
                            );
                          }));
                    } else if (!changed) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Color.fromARGB(255, 248, 136, 44),
                        content: Text(
                            'تعذّر تحديث كلمة المرور, لم تقم بأي تعديلات على كلمة مرورك القديمة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 0.8,
                                fontFamily: 'Tajawal')),
                        action: null,
                      ));
                    } else if (!confirmed) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Color.fromARGB(255, 248, 136, 44),
                        content: Text(
                            'تعذّر تحديث كلمة المرور, تأكيد كلمة المرور الجديدة غير متطابق',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 0.8,
                                fontFamily: 'Tajawal')),
                        action: null,
                      ));
                    } else if (!isValidNewPass) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Color.fromARGB(255, 248, 136, 44),
                        content: Text(
                            'تعذّر تحديث كلمة المرور, كلمة المرور الجديدة ضعيفة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 0.8,
                                fontFamily: 'Tajawal')),
                        action: null,
                      ));
                    }
                  },
                  child: Text(
                    'تحديث كلمة المرور',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  late bool isMatch;
  late bool isSamePass;

  bool ConfirmationResult(newpass, repeatNewpass) {
    if (newpass != repeatNewpass)
      isMatch = false;
    else
      isMatch = true;

    return isMatch;
  }

  bool noChange(currentPass, newpass) {
    if (currentPass != newpass)
      isSamePass = false;
    else
      isSamePass = true;

    return isSamePass;
  }

  bool get isValidNewPass {
    final passRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passRegExp.hasMatch(newPasswordController.text);
  }

  static Future<String?> saveChanges(
      String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

    Map<String, String?> codeResponses = {
      // Re-auth responses
      "user-mismatch": 'المستخدم غير متطابق',
      "user-not-found": 'لم يتم العثور على المستخدم',
      "invalid-credential": 'invalid credential',
      "invalid-email": 'الايميل غير موجود',
      "wrong-password": 'كلمة المرور الحالية خاطئة',
      "invalid-verification-code": 'رمز التحقق غير صالح',
      "invalid-verification-id": 'معرّف التحقق غير صالح',
      // Update password error codes
      "weak-password": 'كلمة المرور غير قوية',
      "requires-recent-login": 'يتطلب تسجيل دخول حديث'
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return await null;
    } on FirebaseAuthException catch (error) {
      return await codeResponses[error.code] ?? "Unknown";
    }
  }
}
