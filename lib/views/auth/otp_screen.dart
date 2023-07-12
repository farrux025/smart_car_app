import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';

import '../../main.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _pinController = TextEditingController();

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
              Flexible(flex: 1, child: Align(alignment:Alignment.topRight,child: xaperText())),
              Flexible(
                  flex: 11,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppText("ENTER OTP",
                          textColor: AppColor.textColor,
                          size: 18.sp,
                          fontWeight: FontWeight.w600),
                      AppText("Enter the OTP recieved in your mobile number",
                          textColor: AppColor.buttonRightColor,
                          maxLines: 2,
                          size: 12.sp,
                          fontWeight: FontWeight.w400),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.disabled,
                          autoFocus: true,
                          hintCharacter: "0",
                          pinTheme: PinTheme(
                              activeColor: AppColor.textColor,
                              selectedColor: AppColor.textColor,
                              inactiveColor: Colors.black.withOpacity(0.2),
                              errorBorderColor: AppColor.errorColor),
                          textStyle: TextStyle(
                              fontSize: 30.sp,
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText("Didn’t Recieved ?",
                              textColor: AppColor.buttonRightColor,
                              size: 11.sp,
                              fontWeight: FontWeight.w400),
                          Container(
                            width: 120.w,
                            height: 29.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColor.textColor, width: 1.sp)),
                            child: MaterialButton(
                              onPressed: () {
                                log("Re-Send");
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
                            log("Enter and procced");
                          },
                          height: 57.h,
                          elevation: 3.sp,
                          child: AppText("Enter and procced",
                              textColor: AppColor.white,
                              size: 14.sp,
                              fontWeight: FontWeight.w500),
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
