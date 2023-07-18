import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/components/app_text_form_field.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/constants.dart';
import 'package:smart_car_app/cubit/register_cubit.dart';

import '../../utils/functions.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          var read = context.read<RegisterCubit>();
          var watch = context.watch<RegisterCubit>();
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: ScreenUtil().screenHeight,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(flex: 1, child: xaperText()),
                      Flexible(
                        flex: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AppText("WELCOME TO ELICA",
                                      size: 44.sp,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 2,
                                      textColor: AppColor.textColor),
                                  AppText("REGISTER",
                                      size: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      textColor: AppColor.textColor),
                                  Form(
                                    key: watch.formKey,
                                    child: AppTextFormField(
                                        textEditingController:
                                            watch.phoneController,
                                        hint: '(90) 123-45-67',
                                        inputFormatter: [Mask.PHONE_NUMBER],
                                        prefix: AppText(PREFIX,
                                            textColor: AppColor.textColor,
                                            fontWeight: FontWeight.w500),
                                        validator: (val) => AppTextValidator(
                                            watch.phoneController.text,
                                            required: true,
                                            minLength: 14),
                                        keyboardType: TextInputType.phone,
                                        suffixIcon: Icon(Icons.phone_android,
                                            color: AppColor.textColor,
                                            size: 24.sp)),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                          log("Enter and procced");
                                          log("STATE: ${state.toString()}");
                                          read.register();
                                          if (state is RegisterLoading) {
                                            log("RegisterLoading");
                                            loadingAlert();
                                          } else if (state is RegisterError) {
                                            log("RegisterError");
                                            log("ERROR");
                                          } else if (state is RegisterLoaded) {
                                            log("RegisterLoaded");
                                          }
                                        },
                                        height: 57.h,
                                        elevation: 3.sp,
                                        child: AppText("Enter and procced",
                                            textColor: AppColor.white,
                                            size: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText("Already have an account?",
                                            textColor:
                                                AppColor.buttonRightColor,
                                            size: 11.sp,
                                            fontWeight: FontWeight.w400),
                                        Container(
                                          width: 120.w,
                                          height: 29.h,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.textColor,
                                                  width: 1.sp)),
                                          child: MaterialButton(
                                            onPressed: () {
                                              log("Sign in Now");
                                              notWorking();
                                            },
                                            child: AppText("Sign in Now",
                                                textColor: AppColor.textColor,
                                                textAlign: TextAlign.start,
                                                size: 11.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppText(
                                      "Terms and condition will goes here with more creative way",
                                      size: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColor.textColor,
                                      maxLines: 3,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget xaperText() {
  return AppText("X  A  P  E  R",
      size: 16.sp,
      fontFamily: 'Poppins Black',
      fontWeight: FontWeight.w900,
      textColor: AppColor.textColor);
}
