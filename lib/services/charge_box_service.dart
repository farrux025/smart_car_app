import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_car_app/constants/variables.dart';

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
    Response response =
        await DioClient.instance.get(AppUrl.chargeBoxImageUrl(id));
    log("Image response: $response");
    return response;
  }
}
