import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/models/auth/RegisterRequest.dart';
import 'package:smart_car_app/services/auth_service.dart';

import '../constants/constants.dart';
import '../utils/functions.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  RegisterRequest? registerRequest;

  register() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoading());
      var text = phoneController.text;
      var phone = getPhone(PREFIX + text);
      log("PHONE: $phone");
      var request = RegisterRequest(phone: phone);
      await AuthService.doRegister(request).then((value) {
        emit(RegisterLoaded());
      });
    }
  }
}
