import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
