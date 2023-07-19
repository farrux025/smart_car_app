import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/constants/constants.dart';
import 'package:smart_car_app/models/auth/LoginRequest.dart';
import 'package:smart_car_app/services/auth_service.dart';
import 'package:smart_car_app/utils/functions.dart';

import '../constants/routes.dart';
import '../main.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var formKeyPassword = GlobalKey<FormState>();
  LoginRequest? loginRequest;

  login() async {
    try {
      if (formKey.currentState!.validate() &&
          formKeyPassword.currentState!.validate()) {
        String phone = getPhone(PREFIX + phoneController.text);
        log("PHONE: $phone");
        String password = passwordController.text;
        var loginRequest = LoginRequest(username: phone, password: password);
        await AuthService.doLogin(loginRequest).then((response) {
          if (response.statusCode == 200) {
            emit(LoginLoaded());
            MyApp.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil(Routes.home, (route) => false);
          }
        });
      }
    } on DioException catch (exception) {
      emit(LoginError());
      log("Login error: ${exception.response?.data}");
      if (exception.response?.data['detail'] == 'Bad credentials') {
        openSnackBar(message: "Telefon raqam yoki parol noto'g'ri");
      } else {
        openSnackBar(message: "${exception.response?.data['detail']}");
      }
    }
  }
}
