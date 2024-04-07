part of 'charge_boxes_map_cubit.dart';

@immutable
abstract class ChargeBoxesMapState extends Equatable {}

// class ChargeBoxesInitial extends ChargeBoxesState {
//   @override
//   List<Object?> get props => [];
// }

class ChargeBoxesMapLoading extends ChargeBoxesMapState {
  @override
  List<Object?> get props => [];
}

class ChargeBoxesMapLoaded extends ChargeBoxesMapState {
  final List<ChargeBoxInfo> list;

  ChargeBoxesMapLoaded(this.list);

  @override
  List<Object?> get props => [list];
}

class ChargeBoxesMapError extends ChargeBoxesMapState {
  final String error;

  ChargeBoxesMapError(this.error);

  @override
  List<Object?> get props => [error];
}
