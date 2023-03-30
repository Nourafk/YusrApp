import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String? text;
  double? fontSize;
  TextAlign? textAlign;
  Color? color;
  bool? underline;
  FontWeight? fontWeight;
  int? maxLines;
  String? fontFamily;

  CustomText(this.text,
      {this.fontSize,
      this.textAlign,
      this.color,
      this.fontWeight,
      this.underline = false,
      this.maxLines,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: fontSize ?? 18,
        color: color ?? Colors.black,
        fontFamily: fontFamily ?? 'Urbanist',
        decoration: underline! ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}
