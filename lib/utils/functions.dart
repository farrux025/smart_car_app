import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/services/auth_service.dart';

import '../constants/routes.dart';
import '../models/global/LocationModel.dart';

closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

notWorking() {
  openSnackBar(
      message: "Ushbu bo'lim ishlab chiqish jarayonida.",
      background: Colors.green.withOpacity(0.8));
}

openLoading() {
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

popBack() {
  MyApp.navigatorKey.currentState?.pop();
}

String getPhone(String phone) {
  return phone
      .replaceAll(" ", "")
      .replaceAll("+", "")
      .replaceAll("-", "")
      .replaceAll("(", "")
      .replaceAll(")", "");
}

String distance({required double lat, required double lon}) {
  String distance;
  var distanceBetween = Geolocator.distanceBetween(
      LocationModel.latitude!, LocationModel.longitude!, lat, lon);
  // log("Distance between: $distanceBetween");
  if (distanceBetween.toInt() > 1000) {
    double d = distanceBetween.toInt() / 1000;
    var distanceString = d.toString();
    distance =
        "${distanceString.replaceRange(distanceString.length - 1, distanceString.length, "")} km Away";
  } else {
    distance = "${distanceBetween.toInt()} m Away";
  }
  return distance;
}

String separator(String str) {
  var db = double.parse(str).toString();
  var split = db.split(".");
  var rev = StringUtils.reverse(split[0]);
  var sep = StringUtils.addCharAtPosition(rev, ",", 3, repeat: true);
  var seq = StringUtils.reverse(sep);
  return "$seq.${split[1]}";
}

Future<PackageInfo> packageInfo() async {
  return await PackageInfo.fromPlatform();
}

logOut(BuildContext context) {
  Widget cancelButton = TextButton(
    child: AppText("Yo'q",
        size: 14.sp,
        fontWeight: FontWeight.bold,
        textColor: AppColor.textColorBlue),
    onPressed: () {
      MyApp.navigatorKey.currentState?.pop();
    },
  );
  Widget continueButton = TextButton(
    child: AppText("Ha",
        size: 14.sp,
        fontWeight: FontWeight.bold,
        textColor: AppColor.textColorBlue),
    onPressed: () => AuthService.logout(),
  );

  AlertDialog dialog = AlertDialog(
    title: AppText("Akkauntdan chiqish",
        size: 18.sp,
        fontWeight: FontWeight.bold,
        textColor: AppColor.textColor),
    content: AppText(
        "Siz haqiqatdan ham akkauntingizdan chiqishni hohlaysizmi?",
        size: 16.sp,
        fontWeight: FontWeight.w400,
        maxLines: 3,
        textColor: AppColor.textColor),
    actions: [cancelButton, continueButton],
  );

  showDialog(context: context, builder: (ctx) => dialog);
}
