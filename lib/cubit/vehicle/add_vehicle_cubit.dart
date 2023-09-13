import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/models/auth/LoginRequest.dart';
import 'package:smart_car_app/models/vehicle/add_vehicle/req/RequestAddVehicle.dart';
import 'package:smart_car_app/models/vehicle/add_vehicle/res/ResponseAddVehicle.dart';
import 'package:smart_car_app/services/auth_service.dart';
import 'package:smart_car_app/services/dio/dio_client.dart';
import 'package:smart_car_app/services/secure_storage.dart';

import '../../models/global/UserModel.dart';

part 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  AddVehicleCubit() : super(AddVehicleLoading());

  addVehicle({required RequestAddVehicle request}) async {
    try {
      await _doAddVehicle(request: request).then((res) {
        if (res.statusCode == 201) {
          ResponseAddVehicle vehicle = ResponseAddVehicle.fromJson(res.data);
          log("Response: $res");
          log("Vehicle: ${vehicle.carNumber}");
        }
      });
    } on DioException catch (e) {
      log("Dio exception add vehicle: $e");
      emit(AddVehicleError(e.toString()));
    } catch (e) {
      log("Error add vehicle: $e");
      emit(AddVehicleError(e.toString()));
    }
  }

  Future<Response<dynamic>> _doAddVehicle(
      {required RequestAddVehicle request}) async {
    var phone = await SecureStorage.read(key: SecureStorage.phone);
    var password = await SecureStorage.read(key: SecureStorage.password);
    await AuthService.doLogin(
        LoginRequest(username: phone, password: password, rememberMe: true));
    var token = await SecureStorage.read(key: SecureStorage.token);
    return await DioClient.instance.post(AppUrl.addVehicleUrl(),
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}
