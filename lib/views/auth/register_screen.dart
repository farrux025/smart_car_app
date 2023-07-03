import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/components/app_text_form_field.dart';
import 'package:smart_car_app/constants/color.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  child: AppText("X A P E R",
                      size: 16.sp,
                      textAlign: TextAlign.left,
                      fontFamily: 'Poppins Black',
                      fontWeight: FontWeight.w900,
                      textColor: AppColor.textColor)),
              Flexible(
                  flex: 3,
                  child: AppText("WELCOME TO ELICA",
                      size: 50.sp,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      textColor: AppColor.textColor)),
              Flexible(
                  flex: 2,
                  child: AppText("REGISTER",
                      size: 20.sp,
                      fontWeight: FontWeight.w400,
                      textColor: AppColor.textColor)),
              Flexible(
                  child: AppTextFormField(
                      hint: 'Enter your phone number',
                      suffixIcon: Icon(Icons.phone_android,
                          color: AppColor.textColor, size: 24.sp)))
            ],
          ),
        ),
      ),
    );
  }
}
