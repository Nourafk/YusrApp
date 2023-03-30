import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text)
          .then((value) => Navigator.of(context).pop());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا'),
                  )
                ]);
          });
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
        "requires-recent-login": 'يتطلب تسجيل دخول حديث',
        '': e.message.toString()
      };
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(codeResponses[e.code]!), actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'حسنًا'),
                child: const Text('حسنًا'),
              )
            ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/yusrResetpass.png"),
                    fit: BoxFit.fill)),
          ),
          toolbarHeight: 170,
          //leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).size.height * 0.1,
                    20,
                    MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  "لطفًا، أدخل بريدك الإلكتروني ليتم إرسال رابط إعادة تعيين كلمة المرور : ",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Color.fromARGB(255, 79, 79, 81)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, right: 20, left: 20, bottom: 50),
                child: TextFormField(
                  controller: _emailController,

                  validator: MultiValidator([
                    RequiredValidator(errorText: 'مطلوب *'),
                    EmailValidator(errorText: 'البريد الإلكتروني غير صالح*')
                  ]),
                  cursorColor: Color.fromARGB(255, 35, 35, 35),
                  style: TextStyle(color: Color(0XFFd7ab65).withOpacity(0.9)),

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 156, 156, 156),
                            width: 0.7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0XFFd7ab65), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 156, 156, 156),
                          width: 1.0),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 156, 156, 156),
                    ),
                    iconColor: Colors.white,
                    labelText: "أدخل بريدك الإلكتروني*",
                    labelStyle: TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
                    // border: OutlineInputBorder(
                    //  borderRadius: BorderRadius.circular(30.0),),
                  ),

                  keyboardType: TextInputType.emailAddress,
                  //--------------------------------------
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, right: 20, left: 20, bottom: 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      resetPass();
                    },
                    //ButtonStyle: BorderRadius.circular(30),
                    child: Text(
                      "إعادة تعيين كلمة المرور",
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)))),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future resetpassOnPressed() async {
    resetPass();
  }
}
