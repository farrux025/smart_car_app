import 'dart:developer';

import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/components/app_text_form_field.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/constants.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/cubit/register_cubit.dart';
import 'package:smart_car_app/main.dart';

import '../../utils/functions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      xaperText(),
                      SizedBox(height: 40.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppText("WELCOME TO ELICA",
                                  size: 44.sp,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 2,
                                  textColor: AppColor.textColor),
                              SizedBox(height: 40.h),
                              AppText("REGISTER",
                                  size: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColor.textColor),
                              SizedBox(height: 30.h),
                              titleTextField(title: "Phone number"),
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
                              ),
                              SizedBox(height: 20.h),
                              titleTextField(title: "Password"),
                              Form(
                                key: watch.formKeyPass,
                                child: FancyPasswordField(
                                  controller: watch.passwordController,
                                  hasStrengthIndicator: false,
                                  validator: (val) => AppTextValidator(
                                      watch.passwordController.text,
                                      required: true,
                                      minLength: 4),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              titleTextField(title: "Confirm password"),
                              Form(
                                key: watch.formKeyConfirmPass,
                                child: FancyPasswordField(
                                  controller: watch.confirmPasswordController,
                                  hasStrengthIndicator: false,
                                  validator: (val) => AppTextValidator(
                                      watch.confirmPasswordController.text,
                                      required: true,
                                      equalText: watch.passwordController.text),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 50.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    log("STATE: $state");
                                    read.register();
                                    // if (state is RegisterLoading) {
                                    //   openLoading();
                                    // }
                                  },
                                  height: 57.h,
                                  elevation: 3.sp,
                                  child: state is RegisterLoaded ||
                                          state is RegisterInitial ||
                                          state is RegisterError
                                      ? AppText("Enter and procced",
                                          textColor: AppColor.white,
                                          size: 14.sp,
                                          fontWeight: FontWeight.w500)
                                      : const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                              color: AppColor.white),
                                        ),
                                ),
                              ),
                              SizedBox(height: 40.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText("Already have an account?",
                                      textColor: AppColor.buttonRightColor,
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
                                        MyApp.navigatorKey.currentState
                                            ?.pushNamed(Routes.login);
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
                              SizedBox(height: 30.h),
                              AppText(
                                "Terms and condition will goes here with more creative way",
                                size: 11.sp,
                                fontWeight: FontWeight.w400,
                                textColor: AppColor.textColor,
                                maxLines: 3,
                              ),
                              SizedBox(height: 30.h),
                            ],
                          )
                        ],
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

Widget titleTextField({required String title}) {
  return AppText(title,
      textColor: AppColor.textColor, size: 12.sp, fontWeight: FontWeight.w500);
}

Widget xaperText() {
  return AppText("X  A  P  E  R",
      size: 16.sp,
      fontFamily: 'Poppins Black',
      fontWeight: FontWeight.w900,
      textColor: AppColor.textColor);
}

/*validationRules: {
                                      DigitValidationRule(),
                                      UppercaseValidationRule(),
                                      // LowercaseValidationRule(),
                                      // SpecialCharacterValidationRule(),
                                      MinCharactersValidationRule(4),
                                      // MaxCharactersValidationRule(12),
                                    },
                                    validationRuleBuilder: (rules, value) {
                                      if (value.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      return ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: rules
                                            .map(
                                              (rule) => rule.validate(value)
                                                  ? Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                          rule.name,
                                                          style: const TextStyle(
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                          rule.name,
                                                          style: const TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            )
                                            .toList(),
                                      );
                                    },*/
