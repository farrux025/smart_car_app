import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/hive/hive_store.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';

import '../../models/global/LocationModel.dart';
import '../../services/charge_box_service.dart';
import '../../utils/functions.dart';

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
          mySort(list);
          MyHiveStore.chargeBox.put(MyHiveBoxName.chargeBox, list);
          emit(ChargeBoxesLoaded(list));
        }
      });
    } on DioException catch (e) {
      log("Charge box cubit ERROR: $e");
      emit(ChargeBoxesError(e.toString()));
    }
  }

  void mySort(List<ChargeBoxInfo> list) {
    list.sort((a, b) {
      var distanceA =
          distance(lat: a.locationLatitude ?? 0, lon: a.locationLongitude ?? 0);
      var distanceB =
          distance(lat: b.locationLatitude ?? 0, lon: b.locationLongitude ?? 0);
      var replaceA = distanceA
          .replaceRange(distanceA.length - 7, distanceA.length, "")
          .trim();
      var replaceB = distanceB
          .replaceRange(distanceB.length - 7, distanceB.length, "")
          .trim();
      return double.parse(replaceA).compareTo(double.parse(replaceB));
    });
  }
}
