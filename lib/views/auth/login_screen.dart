import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/cubit/login_cubit.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';

import '../../components/app_text.dart';
import '../../components/app_text_form_field.dart';
import '../../constants/color.dart';
import '../../constants/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          var watch = context.watch<LoginCubit>();
          var read = context.read<LoginCubit>();
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
                              AppText("LOGIN",
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
                                key: watch.formKeyPassword,
                                child: FancyPasswordField(
                                  controller: watch.passwordController,
                                  hasStrengthIndicator: false,
                                  validator: (val) => AppTextValidator(
                                      watch.passwordController.text,
                                      required: true,
                                      minLength: 4),
                                ),
                              ),
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
                                    read.login();
                                    // if (state is LoginLoading) {
                                    //   openLoading();
                                    // }
                                  },
                                  height: 57.h,
                                  elevation: 3.sp,
                                  child: state is LoginLoaded ||
                                          state is LoginInitial ||
                                          state is LoginError
                                      ? AppText("Login",
                                          textColor: AppColor.white,
                                          size: 14.sp,
                                          fontWeight: FontWeight.w500)
                                      : const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  color: AppColor.white)),
                                        ),
                                ),
                              ),
                              SizedBox(height: 40.h),
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
