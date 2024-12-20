import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  String text;
  double? size;
  Color? textColor;
  FontWeight? fontWeight;
  int? maxLines;
  TextAlign? textAlign;
  TextDecoration? textDecoration;
  String? fontFamily;
  double? wordSpacing;
  double? height;

  AppText(this.text,
      {super.key,
      this.size,
      this.textColor,
      this.textAlign,
      this.fontWeight,
      this.textDecoration,
      this.fontFamily,
      this.maxLines,
      this.wordSpacing,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: size,
          fontFamily: fontFamily,
          wordSpacing: wordSpacing,
          height: height,
          decoration: textDecoration),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
