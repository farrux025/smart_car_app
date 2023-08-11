part of 'charge_boxes_cubit.dart';

@immutable
abstract class ChargeBoxesState extends Equatable {}

// class ChargeBoxesInitial extends ChargeBoxesState {
//   @override
//   List<Object?> get props => [];
// }

class ChargeBoxesLoading extends ChargeBoxesState {
  @override
  List<Object?> get props => [];
}

class ChargeBoxesLoaded extends ChargeBoxesState {
  final List<ChargeBoxInfo> list;

  ChargeBoxesLoaded(this.list);

  @override
  List<Object?> get props => [list];
}

class ChargeBoxesError extends ChargeBoxesState {
  final String error;

  ChargeBoxesError(this.error);

  @override
  List<Object?> get props => [error];
}
