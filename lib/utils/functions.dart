import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/main.dart';

closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

notWorking() {
  openSnackBar(
      message: "Ushbu bo'lim ishlab chiqish jarayonida.",
      background: Colors.green.withOpacity(0.8));
}

loadingAlert() {
  var context = MyApp.navigatorKey.currentState!.context;
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            elevation: 4,
            title: AppText("Please Wait",
                size: 16.sp,
                textColor: AppColor.textColor,
                fontWeight: FontWeight.w500),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    color: AppColor.textColorBlue, strokeWidth: 3.w),
                SizedBox(width: 20.w),
                AppText("Loading...",
                    textColor: AppColor.textColor,
                    size: 13.sp,
                    fontWeight: FontWeight.w400)
              ],
            ),
          ));
}

String getPhone(String phone) {
  return phone
      .replaceAll(" ", "")
      .replaceAll("+", "")
      .replaceAll("-", "")
      .replaceAll("(", "")
      .replaceAll(")", "");
}
