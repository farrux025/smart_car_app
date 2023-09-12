import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';

import '../../components/app_text.dart';

class ConnectedOrDisconnectedScreen extends StatelessWidget {
  String title;
  String description;
  IconData icon;
  Color iconColor;

  ConnectedOrDisconnectedScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    var height = ScreenUtil().screenHeight;
    var width = ScreenUtil().screenWidth;
    return Scaffold(
      backgroundColor: AppColor.backgroundMain,
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
              width: width,
              bottom: 40.h,
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset(
                  AppImages.carInConnected,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              height: height * 0.6,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 10.h),
                  AppText(title,
                      size: 32.sp,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textColor: AppColor.textSecondary,
                      fontWeight: FontWeight.w700),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: AppText(description,
                        size: 14.sp,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        textColor: AppColor.textSecondary,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                    height: 124,
                    width: 124,
                    decoration: BoxDecoration(
                        border: Border.all(color: iconColor, width: 5.sp),
                        borderRadius: BorderRadius.circular(100.r)),
                    child: Icon(icon, size: 70.sp, color: iconColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
