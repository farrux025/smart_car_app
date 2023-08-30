import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlue,
      body: Stack(
        children: [
          TabBarView(
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
          Positioned(
            width: 90.w,
            left: -20.w,
            top: ScreenUtil().screenHeight * 0.48,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation<double>(1.25),
              child: TabBar(
                // padding: EdgeInsets.symmetric(horizontal: 8.h),
                tabs: List.generate(
                  controller?.length ?? 0,
                  (index) => Tab(icon: Icon(Icons.circle, size: 12.sp)),
                ),
                // indicatorColor: Colors.transparent,
                indicatorWeight: 6,
                indicatorPadding:
                    const EdgeInsets.only(bottom: 22, left: 10, top: 16),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(6), // Creates border
                    color: Colors.white),
                unselectedLabelColor: AppColor.unselectedIndicatorColor,
                automaticIndicatorColorAdjustment: true,
                controller: controller,
                labelColor: Colors.transparent,
              ),
            ),
          )
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
              MyApp.navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil(Routes.register, (route) => false);
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
