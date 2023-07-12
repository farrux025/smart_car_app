import 'dart:developer';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';

import '../../constants/color.dart';

class OtpWaitingScreen extends StatefulWidget {
  const OtpWaitingScreen({super.key});

  @override
  State<OtpWaitingScreen> createState() => _OtpWaitingScreenState();
}

class _OtpWaitingScreenState extends State<OtpWaitingScreen>
    with SingleTickerProviderStateMixin {
  double percent = 0.0;
  int maxDuration = 10;
  late final CustomTimerController _timerController = CustomTimerController(
      vsync: this,
      begin: Duration(seconds: maxDuration),
      end: const Duration(seconds: 0),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.seconds);

  @override
  void initState() {
    super.initState();
    _timerController.start();
    _timerController.addListener(() {});
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: ScreenUtil().screenHeight,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Column(
          children: [
            Flexible(
                flex: 1,
                child:
                    Align(alignment: Alignment.topRight, child: xaperText())),
            Flexible(
              flex: 11,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("WAITING FOR THE OTP",
                      size: 38.sp,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      textColor: AppColor.textColor),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: CircularPercentIndicator(
                      radius: 80.r,
                      animationDuration: 5,
                      lineWidth: 5.sp,
                      backgroundWidth: 3.sp,
                      percent: 0.6,
                      animation: true,
                      animateFromLastPercent: true,
                      backgroundColor: AppColor.secondary,
                      progressColor: AppColor.textColor,
                      center: CustomTimer(
                          controller: _timerController,
                          builder: (state, time) {
                            return AppText("${time.minutes}:${time.seconds}",
                                textColor: AppColor.textColor,
                                size: 16.sp,
                                fontWeight: FontWeight.w500);
                          }),
                    ),
                  ),
                  Container(
                    // height: 66.h,
                    color: AppColor.secondary,
                    width: ScreenUtil().screenHeight,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            log("Cancel");
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 6.sp, right: 6.sp),
                              child: Icon(Icons.cancel_outlined,
                                  color: AppColor.textColorBlue, size: 18.sp),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30.w, right: 30.w, bottom: 20.h),
                          child: AppText(
                              "Terms and condition will goes here with more creative way",
                              maxLines: 3,
                              size: 11.sp,
                              fontWeight: FontWeight.w400,
                              textColor: AppColor.textColorBlue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 57.h,
                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        AppColor.buttonLeftColor.withOpacity(0.2),
                        AppColor.buttonRightColor.withOpacity(0.2)
                      ])),
                      child: MaterialButton(
                          onPressed: () {
                            log("Enter otp");
                            MyApp.navigatorKey.currentState
                                ?.pushNamed(Routes.otp);
                          },
                          child: AppText("ENTER OTP",
                              size: 14.sp,
                              textColor: AppColor.white,
                              fontWeight: FontWeight.w500)))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
