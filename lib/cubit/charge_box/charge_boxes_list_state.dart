part of 'charge_boxes_list_cubit.dart';

@immutable
abstract class ChargeBoxesListState extends Equatable {}

// class ChargeBoxesInitial extends ChargeBoxesState {
//   @override
//   List<Object?> get props => [];
// }

class ChargeBoxesListLoading extends ChargeBoxesListState {
  @override
  List<Object?> get props => [];
}

class ChargeBoxesListLoaded extends ChargeBoxesListState {
  final List<ChargeBoxInfo> list;

  ChargeBoxesListLoaded(this.list);

  @override
  List<Object?> get props => [list];
}

class ChargeBoxesListError extends ChargeBoxesListState {
  final String error;

  ChargeBoxesListError(this.error);

  @override
  List<Object?> get props => [error];
}
