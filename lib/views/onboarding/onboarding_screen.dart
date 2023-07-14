import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlue,
      body: PageView(
        controller: controller,
        children: [
          pageItem(
              index: 1,
              title: "YOUR SMART CAR",
              imagePath: AppImages.onBoarding1),
          pageItem(
              index: 2,
              title: "ELECTRIC CHARGING",
              imagePath: AppImages.onBoarding2),
          pageItem(
              index: 3,
              title: "FIND CHARGING STATION",
              imagePath: AppImages.onBoarding3)
        ],
      ),
    );
  }

  pageItem(
      {required int index, required String title, required String imagePath}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          xaperText(),
          Image.asset(imagePath,
              fit: BoxFit.fill,
              height: ScreenUtil().screenHeight * 0.6,
              width: ScreenUtil().screenWidth * 0.6),
          AppText(title,
              size: 16.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColor.textColor),
          TextButton(
            onPressed: () {
              MyApp.navigatorKey.currentState?.pushNamed(Routes.home);
              log("SKIP");
            },
            child: AppText(index == 3 ? "CONTINUE" : "SKIP",
                size: 14.sp,
                fontWeight: FontWeight.w500,
                textColor: AppColor.textColorBlue),
          ),
        ],
      ),
    );
  }
}
