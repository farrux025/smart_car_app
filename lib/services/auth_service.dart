import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/models/auth/RegisterRequest.dart';
import 'package:smart_car_app/services/secure_storage.dart';

import '../constants/routes.dart';
import '../main.dart';
import '../models/auth/LoginRequest.dart';
import 'dio/dio_client.dart';

class AuthService {
  // ***************************************************************************

  static Future<Response> doRegister(RegisterRequest registerRequest) async {
    var config = getRegisterConfig();
    config['phone'] = registerRequest.phone;
    config['login'] = registerRequest.phone;
    config['password'] = registerRequest.password;
    log("Config: $config");
    var options = Options(headers: {"Content-type": "application/json"});
    Response response = await DioClient.instance
        .post(AppUrl.registerUrl, data: config, options: options);
    log("Register response: $response");
    return response;
    // try {
    //
    //
    //   if (response.statusCode == 201) {
    //     openSnackBar(
    //         message: "User Created Successfully",
    //         background: Colors.green.withOpacity(0.8));
    //     SecureStorage.write(
    //         key: SecureStorage.phone, value: registerRequest.phone ?? '');
    //     MyApp.navigatorKey.currentState
    //         ?.pushNamedAndRemoveUntil(Routes.home, (route) => false);
    //   }
    // } on DioError catch (e) {
    //   log("KeycloakClientDio.checkLoginError: ${e.response?.data}");
    //   if ((e.response?.data['errorKey']) == 'emailexists') {
    //     openSnackBar(message: "User is available already!");
    //   }
    // }
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
      "password": "123456"
    };
  }

  // ***************************************************************************

  static Future<Response> doLogin(LoginRequest loginRequest) async {
    var loginConfig = getLoginConfig();
    loginConfig['username'] = loginRequest.username;
    loginConfig['password'] = loginRequest.password;
    log("Config: $loginConfig");
    Response response =
        await DioClient.instance.post(AppUrl.loginUrl, data: loginConfig);
    log("Login response: $response");
    if (response.statusCode == 200) {
      SecureStorage.write(
          key: SecureStorage.token, value: response.data['id_token']);
    }
    return response;
  }

  // ***************************************************************************

  static Map<String, dynamic> getLoginConfig() {
    return {"username": "mobile", "password": "123456", "rememberMe": true};
  }

  // ***************************************************************************

  static Future<Response> doActivate({required String otp}) async {
    Response response =
        await DioClient.instance.get("${AppUrl.otpActivateUrl}?key=$otp");
    log("Otp activate response: $response");
    return response;
  }

  static logout() async {
    log("USER LOG OUT!");
    await SecureStorage.clearSecureStorage();
    MyApp.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(Routes.register, (route) => false);
    await SecureStorage.read(key: SecureStorage.phone).then((value) {
      log("Saved phone: $value");
    });
  }
}
