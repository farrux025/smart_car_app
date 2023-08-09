import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/color.dart';
import '../main.dart';
import 'app_text.dart';

openSnackBar({required String message, Color? background}) {
  var context = MyApp.navigatorKey.currentState!.context;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      margin: EdgeInsets.all(16.sp),
      behavior: SnackBarBehavior.floating,
      content: AppText(message,
          maxLines: 3, size: 14.0.sp, textColor: AppColor.white),
      padding: EdgeInsets.all(16.sp),
      backgroundColor: background ?? Colors.red.withOpacity(0.7)));
}

alert(
    {String? title,
    String? content,
    required String buttonText,
    required VoidCallback onPressed}) {
  return SimpleDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    title: title != null
        ? AppText(
            title,
            textColor: AppColor.textColor,
            size: 16.sp,
            fontWeight: FontWeight.w600,
          )
        : const SizedBox(),
    children: [
      content != null
          ? AppText(
              content,
              size: 14.sp,
              textColor: AppColor.textColor,
              fontWeight: FontWeight.w400,
            )
          : const SizedBox(),
      SizedBox(height: 12.h),
      MaterialButton(
        onPressed: onPressed,
        minWidth: ScreenUtil().screenWidth,
        color: const Color(0xFF19794C),
        height: 36.h,
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: AppText(
          buttonText,
          textColor: AppColor.white,
          fontWeight: FontWeight.w500,
          size: 14.sp,
        ),
      )
    ],
  );
}

toast({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.buttonLeftColor.withOpacity(0.7),
      textColor: AppColor.white,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.sp,
      toastLength: Toast.LENGTH_SHORT);
}
