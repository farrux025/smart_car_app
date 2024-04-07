import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/services/auth_service.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:smart_car_app/services/shared_prefs.dart';

import 'dio/dio_client.dart';

class ChargeBoxService {
  static Future<Response<List<dynamic>>> doGetChargeBoxesForMap(
      {required String lat,
      required String lon,
      required String distance}) async {
    // var options = Options(headers: {"Content-type": "application/json"});
    var connectorIdList = await MySharedPrefs().getConnectorTypeList();
    log("ConnectorTypeList: $connectorIdList");
    Response<List<dynamic>> response = await DioClient.instance.get(
        AppUrl.chargeBoxListUrlForMap(lat, lon, distance),
        queryParameters: {'connectorId.in': connectorIdList});
    log("Charge box list response: $response");
    return response;
  }

  // ***************************************************************************

  static Future<Response<List<dynamic>>> doGetChargeBoxesForList({
    required String lat,
    required String lon,
    required String distance,
    int? page,
  }) async {
    var connectorIdList = await MySharedPrefs().getConnectorTypeList();
    log("ConnectorTypeList: $connectorIdList");
    Response<List<dynamic>> response = await DioClient.instance.get(
        AppUrl.chargeBoxListUrlForMap(lat, lon, distance),
        queryParameters: {
          'connectorId.in': connectorIdList,
          'size': 20,
          'page': page,
        });
    log("Charge box list response: $response");
    return response;
  }

  // ***************************************************************************

  // static Future<Response<List<dynamic>>> doGetChargeBoxesForList() async {
  //   var connectorIdList = await MySharedPrefs().getConnectorTypeList();
  //   log("ConnectorTypeList: $connectorIdList");
  //   Response<List<dynamic>> response = await DioClient.instance.get(
  //       AppUrl.chargeBoxListUrl(),
  //       queryParameters: {'connectorId.in': connectorIdList, 'size': 30});
  //   log("Charge box list response: $response \n\nLength: ${response.data?.length}");
  //   return response;
  // }

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

  static Future<Response> doGetPublicDetails({required num chargeBoxId}) async {
    Response response = await DioClient.instance.get(
        AppUrl.chargeBoxPublicDetails(),
        queryParameters: {"id": chargeBoxId});
    log("Public details response: $response");
    return response;
  }

  // ***************************************************************************

  static Future<Response> doGetConnectorTypes() async {
    Response response = await DioClient.instance.get(AppUrl.connectorTypes());
    log("Connector types response: $response");
    return response;
  }
}
