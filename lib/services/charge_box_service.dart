import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/services/secure_storage.dart';

import 'dio/dio_client.dart';

class ChargeBoxService {
  static Future<Response<List<dynamic>>> doGetChargeBoxes(
      {required String lat,
      required String lon,
      required String distance}) async {
    // var options = Options(headers: {"Content-type": "application/json"});
    Response<List<dynamic>> response = await DioClient.instance
        .get(AppUrl.chargeBoxListUrl(lat, lon, distance));
    log("Charge box list response: $response");
    return response;
  }

  // ***************************************************************************

  static Future<Response> doGetImages({required String id}) async {
    String token = '';
    await SecureStorage.read(key: SecureStorage.token)
        .then((value) => token = value);
    var options = Options(headers: {"Authorization": "Bearer $token"});
    Response response = await DioClient.instance
        .get(AppUrl.chargeBoxImageUrl(id), options: options);
    log("Image response: $response");
    return response;
  }

  // ***************************************************************************

  static Future<Response> doGetPublicDetails(
      {required String chargeBoxId}) async {
    Response response = await DioClient.instance
        .get(AppUrl.chargeBoxPublicDetails(), queryParameters: {"id": chargeBoxId});
    log("Public details response: $response");
    return response;
  }
}
