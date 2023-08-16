import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';

import '../../models/global/LocationModel.dart';
import '../../services/charge_box_service.dart';

part 'charge_boxes_state.dart';

class ChargeBoxesCubit extends Cubit<ChargeBoxesState> {
  ChargeBoxesCubit() : super(ChargeBoxesLoading()) {
    getChargeBoxes();
  }

  getChargeBoxes() async {
    try {
      emit(ChargeBoxesLoading());
      await ChargeBoxService.doGetChargeBoxes(
              lat: LocationModel.latitude.toString(),
              lon: LocationModel.longitude.toString(),
              distance: "1000000")
          .then((response) {
        if (response.statusCode == 200) {
          List<ChargeBoxInfo> list = [];
          response.data?.forEach((element) {
            var chargeBoxInfo = ChargeBoxInfo.fromJson(element);
            list.add(chargeBoxInfo);
          });
          emit(ChargeBoxesLoaded(list));
        }
      });
    } on DioException catch (e) {
      log("Charge box cubit ERROR: $e");
      emit(ChargeBoxesError(e.toString()));
    }
  }
}
