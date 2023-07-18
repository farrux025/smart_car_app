import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/models/auth/RegisterRequest.dart';
import 'package:smart_car_app/services/secure_storage.dart';

import 'dio/dio_client.dart';

class AuthService {
  // ***************************************************************************

  static Future doRegister(RegisterRequest registerRequest) async {
    try {
      var config = getRegisterConfig();
      config['phone'] = registerRequest.phone;
      log("Config: $config");
      var options = Options(headers: {"Content-type": "application/json"});
      Response response = await DioClient.instance
          .post(AppUrl.registerUrl, data: config, options: options);
      log("Register response: $response");
      if (response.statusCode == 201) {
        openSnackBar(
            message: "User Created Successfully",
            background: Colors.green.withOpacity(0.8));
        SecureStorage.write(
            key: SecureStorage.phone, value: registerRequest.phone ?? '');
        MyApp.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(Routes.home, (route) => false);
      }
    } on DioError catch (e) {
      log("KeycloakClientDio.checkLoginError: ${e.message}");
    }
  }

  // ***************************************************************************

  static Map<String, dynamic> getRegisterConfig() {
    return {
      "id": 0,
      "login": "string",
      "firstName": "string",
      "lastName": "string",
      "phone": "998943429950",
      "imageUrl": "string",
      "activated": true,
      "langKey": "string",
      "createdBy": "string",
      "createdDate": "2023-07-18T10:57:08.875Z",
      "lastModifiedBy": "string",
      "lastModifiedDate": "2023-07-18T10:57:08.875Z",
      "authorities": ["string"],
      "password": "string"
    };
  }

// ***************************************************************************
}
