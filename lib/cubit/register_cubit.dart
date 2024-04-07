import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/models/auth/RegisterRequest.dart';
import 'package:smart_car_app/services/auth_service.dart';
import 'package:smart_car_app/translations/locale_keys.g.dart';

import '../constants/constants.dart';
import '../constants/routes.dart';
import '../main.dart';
import '../services/secure_storage.dart';
import '../utils/functions.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var formKeyPass = GlobalKey<FormState>();
  var formKeyConfirmPass = GlobalKey<FormState>();
  RegisterRequest? registerRequest;

  register() async {
    try {
      if (formKey.currentState!.validate() &&
          formKeyPass.currentState!.validate() &&
          formKeyConfirmPass.currentState!.validate()) {
        emit(RegisterLoading());
        var text = phoneController.text;
        var phone = getPhone(PREFIX + text);
        var password = passwordController.text;
        log("PHONE: $phone, PASSWORD: $password");
        var request = RegisterRequest(phone: phone, password: password);
        await AuthService.doRegister(request).then((res) {
          if (res.statusCode == 201) {
            emit(RegisterLoaded());
            log("Register successfully");
            SecureStorage.write(key: SecureStorage.phone, value: phone);
            SecureStorage.write(key: SecureStorage.password, value: password);
            SecureStorage.write(key: SecureStorage.otp, value: res.data['message']);
            MyApp.navigatorKey.currentState?.pushNamed(Routes.otp);
            SecureStorage.read(key: SecureStorage.phone).then((value) {
              log("Saved phone::: $value");
            });
          }
        });
      }
    } on DioException catch (e) {
      emit(RegisterError());
      errorToUI(e);
    }
  }

  void errorToUI(DioException exception) {
    if (exception.response?.data['errorKey'] == 'emailexists' ||
        exception.response?.data['errorKey'] == 'userexists') {
      openSnackBar(message: LocaleKeys.this_user_already_exist.tr());
    } else if (exception.type == DioExceptionType.unknown) {
      openSnackBar(message: LocaleKeys.something_went_wrong.tr());
    }
  }
}
