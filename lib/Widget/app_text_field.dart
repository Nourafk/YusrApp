import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AppTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final String hint;
  final String hint2;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final bool addBorder;
  final bool filled;
  Widget? suffix;

  AppTextField(
      {this.keyboardType = TextInputType.text,
      required this.controller,
      this.obscureText = false,
      this.maxLength = 30,
      this.maxLines = 1,
      this.enabled = true,
      this.hint2 = '',
      required this.hint,
      this.addBorder = true,
      this.filled = false,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: TextStyle(height: 1),
      decoration: InputDecoration(
          suffixIcon: suffix,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: hint,
          labelText: hint2,
          counterText: '',
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          disabledBorder: enabledBorder,
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(color: Color(0xffBCBCBC)),
          filled: filled,
          fillColor: Color(0xff575757).withOpacity(0.1)),
    );
  }

  OutlineInputBorder get enabledBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: (addBorder) ? Colors.grey : Colors.transparent,
        ),
      );

  OutlineInputBorder get focusedBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 2,
          color: (addBorder) ? Colors.grey : Colors.transparent,
        ),
      );

  OutlineInputBorder get enabledUnderlineBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: (addBorder) ? Colors.grey : Colors.transparent,
        ),
      );

  UnderlineInputBorder get focusedUnderlineBorder => UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 2,
          color: (addBorder) ? Colors.grey : Colors.transparent,
        ),
      );

  OutlineInputBorder get borderDisable => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          width: 1,
          color: (addBorder) ? Colors.grey.shade200 : Colors.transparent,
        ),
      );
}

///اللي سوتها شوق
Widget textFeild(TextEditingController controller, Icon icon, String lable,
    String hint, String type, valType) {
  return TextFormField(
    enabled: type == "request" ? false : true,
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,

    validator: MultiValidator([
      RequiredValidator(errorText: 'مطلوب *'),
      hint == "name"
          ? PatternValidator(
              r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z\u0600-\u06ff 0-9]{3,30}$',

              ///ازيد اخليه يقبل ارقام وحروف long-description
              errorText: validateName(controller.text))
          : hint == "description"
              ? PatternValidator(
                  r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z\u0600-\u06ff 0-9]{10,1000}$',
                  errorText: validateDescription(controller.text))
              : hint == "long-description"
                  ? PatternValidator(
                      r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z\u0600-\u06ff 0-9]{10,2000}$',
                      errorText: validateDescription(controller.text))
                  : PatternValidator('', errorText: '')
    ]),

    cursorColor: Color.fromARGB(255, 37, 43, 121),
    style: TextStyle(color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

    decoration: InputDecoration(
      contentPadding: hint == "description"
          ? EdgeInsets.only(top: 50, bottom: 50, left: 10)
          : null,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0XFFd7ab65), width: 1.0)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0XFFd7ab65), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0x76909090), width: 1.0),
      ),
      prefixIcon: icon,
      iconColor: Colors.white,
      labelText: lable,
      labelStyle: TextStyle(
          color: Color(0x8F909090).withOpacity(0.9), fontFamily: 'Tajawal'),

      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      // border: OutlineInputBorder(
      //  borderRadius: BorderRadius.circular(30.0),),
    ),

    keyboardType: type == "text"
        ? TextInputType.text
        : type == "url"
            ? TextInputType.url
            : TextInputType.number,
    //--------------------------------------
  );
}

String validateName(String? formName) {
  if (formName!.length < 3)
    return 'يجب أن يتكون الاسم من 3 أحرف فأكثر';
  else if (formName.length > 30)
    return 'يجب أن لا يتجاوز الاسم 30 حرف ';
  else
    return '';
}

String validateDescription(String? formName) {
  if (formName!.length < 10)
    return 'يجب أن يتكون من 10 أحرف فأكثر';
  else
    return '';
}
