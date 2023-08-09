import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_car_app/constants/variables.dart';

import 'dio/dio_client.dart';

class ChargeBoxService {
  static Future<Response> doGetChargeBoxes(
      {required double lat,
      required double lon,
      required double distance}) async {
    Response response = await DioClient.instance
        .get(AppUrl.chargeBoxListUrl(lat, lon, distance));
    // Response response=await DioClient.instance.get(AppUrl.chargeBoxCountUrl());
    log("Charge box list response: $response");
    return response;
  }
}
