import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_car_app/services/charge_box_service.dart';

import '../../models/charge_box/details/PublicDetails.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final String chargeBoxId;

  DetailsCubit(this.chargeBoxId) : super(DetailsInitial()) {
    getPublicDetails(chargeBoxId: chargeBoxId);
  }

  getPublicDetails({required String chargeBoxId}) async {
    emit(DetailsInitial());
    try {
      await ChargeBoxService.doGetPublicDetails(chargeBoxId: chargeBoxId)
          .then((response) {
        if (response.statusCode == 200) {
          PublicDetails details = PublicDetails.fromJson(response.data);
          emit(DetailsLoaded(details));
        }
      });
    } on DioException catch (e) {
      log("Error in getPublicDetails: $e");
      emit(DetailsError(e.toString()));
    } catch (error) {
      emit(DetailsError(error.toString()));
      log('Details cubit public error: $error');
    }
  }
}
