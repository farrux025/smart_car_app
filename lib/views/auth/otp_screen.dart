import 'dart:developer';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';

import '../../main.dart';
import '../../utils/functions.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  double percent = 0.0;
  int maxDuration = 10;

  late final CustomTimerController _timerController = CustomTimerController(
      vsync: this,
      begin: Duration(seconds: maxDuration),
      end: const Duration(seconds: 0),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.seconds);

  bool isReceiveOtp = true;
  bool restartAnimation = false;

  @override
  void initState() {
    super.initState();
    _timerController.start();
    _timerController.addListener(() {
      if (_timerController.state.value == CustomTimerState.finished) {
        setState(() {
          isReceiveOtp = false;
          restartAnimation = true ;
        });
      } else if (_timerController.state.value == CustomTimerState.counting) {
        setState(() {
          isReceiveOtp = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            AppText("ENTER OTP",
                                textColor: AppColor.textColor,
                                size: 18.sp,
                                fontWeight: FontWeight.w600),
                            SizedBox(height: 16.h),
                            AppText(
                                "Enter the OTP recieved in your mobile number",
                                textColor: AppColor.buttonRightColor,
                                maxLines: 2,
                                size: 12.sp,
                                fontWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                controller: _pinController,
                                keyboardType: TextInputType.number,
                                autovalidateMode: AutovalidateMode.disabled,
                                autoFocus: true,
                                hintCharacter: "0",
                                hintStyle: TextStyle(
                                    color: Colors.black12, fontSize: 24.sp),
                                cursorColor: Colors.black,
                                cursorHeight: 20.h,
                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10.r),
                                    fieldHeight: 80,
                                    fieldWidth: 60,
                                    activeColor: AppColor.textColor,
                                    selectedColor: AppColor.textColor,
                                    inactiveColor:
                                        Colors.black.withOpacity(0.2),
                                    errorBorderColor: AppColor.errorColor),
                                textStyle: TextStyle(
                                    fontSize: 30.sp,
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: CircularPercentIndicator(
                                radius: 50.r,
                                animationDuration: 10000,
                                lineWidth: 5.sp,
                                backgroundWidth: 3.sp,
                                percent: 1,
                                animation: true,
                                backgroundColor: AppColor.secondary,
                                progressColor: AppColor.textColor,
                                onAnimationEnd: () {
                                  log("Animation end");
                                },
                                restartAnimation:
                                    restartAnimation ? true : false,
                                addAutomaticKeepAlive: false,
                                center: CustomTimer(
                                    controller: _timerController,
                                    builder: (state, time) {
                                      return AppText(
                                          "${time.minutes}:${time.seconds}",
                                          textColor: AppColor.textColor,
                                          size: 16.sp,
                                          fontWeight: FontWeight.w500);
                                    }),
                              ),
                            ),
                            isReceiveOtp
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText("Didn’t Recieved ?",
                                          textColor: AppColor.buttonRightColor,
                                          size: 11.sp,
                                          fontWeight: FontWeight.w400),
                                      Container(
                                        width: 100.w,
                                        height: 26.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColor.textColor,
                                                width: 1.sp)),
                                        child: MaterialButton(
                                          onPressed: () {
                                            log("Re-Send");
                                            setState(() {
                                              _timerController.start();
                                              setState(() {
                                                isReceiveOtp = true;
                                                restartAnimation = true;
                                              });
                                            });
                                          },
                                          child: AppText("Re-Send",
                                              textColor: AppColor.textColor,
                                              size: 11.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                            Container(
                              width: ScreenUtil().screenWidth,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                AppColor.buttonLeftColor,
                                AppColor.buttonRightColor
                              ])),
                              child: MaterialButton(
                                onPressed: () {
                                  closeKeyboard();
                                  log("ENTER OTP");
                                  MyApp.navigatorKey.currentState
                                      ?.pushNamed(Routes.onBoarding);
                                },
                                height: 57.h,
                                elevation: 3.sp,
                                child: AppText("ENTER OTP",
                                    textColor: AppColor.white,
                                    size: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 50.h)
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
