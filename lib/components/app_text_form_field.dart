import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color.dart';

class AppTextFormField extends StatelessWidget {
  String? labelText;
  FormFieldValidator<String>? validator;
  TextEditingController? textEditingController;
  Icon? prefixIcon;
  List<TextInputFormatter>? inputFormatter;
  Widget? prefix;
  Widget? suffixIcon;
  String? hint;
  int? maxLines;
  int? maxLength;
  TextInputType? keyboardType;
  ValueChanged<String>? onChanged;
  bool? autoFocus;
  bool? readOnly;

  AppTextFormField(
      {this.labelText,
      this.validator,
      this.textEditingController,
      this.prefixIcon,
      this.inputFormatter,
      this.prefix,
      this.suffixIcon,
      this.hint,
      this.maxLines,
      this.maxLength,
      this.keyboardType,
      this.onChanged,
      this.autoFocus,
      this.readOnly,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textEditingController,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly ?? false,
      style: TextStyle(
          fontSize: 14.sp,
          color: AppColor.textColor,
          fontWeight: FontWeight.w500),
      inputFormatters: inputFormatter,
      keyboardType: keyboardType,
      autofocus: autoFocus ?? true,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        hintStyle: TextStyle(
            fontSize: 14.sp, color: AppColor.buttonRightColor.withOpacity(0.5)),
        prefix: prefix,
        prefixIcon: getPrefixIcon(),
        suffixIcon: suffixIcon,
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        // enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(15.r),
        //     borderSide: BorderSide(color: AppColor.buttonColor)),
        fillColor: Colors.black26,
      ),
    );
  }

  getPrefixIcon() {
    return prefixIcon != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: IconTheme(
              data: const IconThemeData(color: AppColor.textColor),
              child: prefixIcon!,
            ),
          )
        : null;
  }
}
