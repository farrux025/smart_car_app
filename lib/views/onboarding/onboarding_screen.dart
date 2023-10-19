import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../translations/locale_keys.g.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  TabController? controller;
  var activeIndex = 0;

  List<OnBoardingDetails> list = [
    OnBoardingDetails(
        title: LocaleKeys.YOUR_SMART_CAR.tr(), imagePath: AppImages.onBoarding1),
    OnBoardingDetails(
        title: LocaleKeys.ELECTRIC_CHARGING.tr(), imagePath: AppImages.onBoarding2),
    OnBoardingDetails(
        title: LocaleKeys.FIND_CHARGING_STATION.tr(), imagePath: AppImages.onBoarding3),
  ];

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
          CarouselSlider.builder(
            itemCount: list.length,
            itemBuilder: (context, index, realIndex) {
              var details = list[index];
              return pageItem(
                  index: index,
                  title: details.title ?? '',
                  imagePath: details.imagePath ?? AppImages.onBoarding1);
            },
            options: CarouselOptions(
              height: ScreenUtil().screenHeight,
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 1,
              scrollDirection: Axis.vertical,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
          ),
          Positioned(
            width: 90.w,
            left: -20.w,
            top: ScreenUtil().screenHeight * 0.45,
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: list.length,
              effect: const ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  dotColor: AppColor.unselectedIndicatorColor,
                  activeDotColor: AppColor.white,
                  spacing: 12),
              axisDirection: Axis.vertical,
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
            child: AppText(index == 3 ? LocaleKeys.CONTINUE.tr() : LocaleKeys.SKIP.tr(),
                size: 14.sp,
                fontWeight: FontWeight.w500,
                textColor: AppColor.textColorBlue),
          ),
        ],
      ),
    );
  }
}

class OnBoardingDetails {
  String? title;
  String? imagePath;

  OnBoardingDetails({this.title, this.imagePath});
}
