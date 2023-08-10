part of 'charge_boxes_cubit.dart';


@immutable
abstract class ChargeBoxesState {}

class ChargeBoxesInitial extends ChargeBoxesState {}

class ChargeBoxesLoading extends ChargeBoxesState {}

class ChargeBoxesLoaded extends ChargeBoxesState {}

class ChargeBoxesError extends ChargeBoxesState {}
