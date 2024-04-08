import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/hive/hive_store.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';
import 'package:smart_car_app/translations/locale_keys.g.dart';

import '../../models/global/LocationModel.dart';
import '../../services/charge_box_service.dart';
import '../../services/shared_prefs.dart';
import '../../utils/functions.dart';

part 'charge_boxes_list_state.dart';

class ChargeBoxesListCubit extends Cubit<ChargeBoxesListState> {
  ChargeBoxesListCubit() : super(ChargeBoxesListLoading()) {
    if (LocationModel.latitude != null && LocationModel.longitude != null) {
      getChargeBoxesForList(
          lat: LocationModel.latitude!, lon: LocationModel.longitude!, page: 0);
    } else {
      String error = LocaleKeys.current_location_not_detected.tr();
      emit(ChargeBoxesListError(error));
    }
  }

  getChargeBoxesForList(
      {required double? lat, required double? lon, int? page}) async {
    try {
      emit(ChargeBoxesListLoading());
      String? dis = await MySharedPrefs().getDistance();
      log("SavedDistance: $dis");
      if (lat != null || lon != null) {
        await ChargeBoxService.doGetChargeBoxesForList(
                lat: lat.toString(),
                lon: lon.toString(),
                distance: dis ?? "100000",
                page: page)
            .then((response) {
          if (response.statusCode == 200) {
            List<ChargeBoxInfo> list = [];
            response.data?.forEach((element) {
              var chargeBoxInfo = ChargeBoxInfo.fromJson(element);
              list.add(chargeBoxInfo);
            });
            mySort(list);
            MyHiveStore.chargeBoxForList
                .put(MyHiveBoxName.chargeBoxForList, list);
            emit(ChargeBoxesListLoaded(list));
          }
        });
      } else {
        String error = LocaleKeys.current_location_not_detected.tr();
        emit(ChargeBoxesListError(error));
      }
    } on DioException catch (e) {
      log("Charge box cubit ERROR: $e");
      emit(ChargeBoxesListError(e.toString()));
    }
  }
}

mySort(List<ChargeBoxInfo> list) {
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
