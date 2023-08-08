import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/services/auth_service.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  var otpController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  activate() async {
    try {
      if (formKey.currentState!.validate()) {
        emit(OtpLoading());
        await AuthService.doActivate(otp: otpController.text.trim())
            .then((response) {
          if (response.statusCode == 200) {
            MyApp.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil(Routes.home, (route) => false);
          }
        });
      }
    } on DioException catch (e) {
      emit(OtpError());
    }
  }
}
