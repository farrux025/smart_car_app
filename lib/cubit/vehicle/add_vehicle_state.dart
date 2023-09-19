part of 'add_vehicle_cubit.dart';

@immutable
abstract class AddVehicleState extends Equatable {}

class AddVehicleInitial extends AddVehicleState {
  @override
  List<Object?> get props => [];
}

class AddVehicleLoading extends AddVehicleState {
  @override
  List<Object?> get props => [];
}

class AddVehicleLoaded extends AddVehicleState {
  final ResponseAddVehicle vehicle;

  AddVehicleLoaded(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class AddVehicleError extends AddVehicleState {
  final String error;

  AddVehicleError(this.error);

  @override
  List<Object?> get props => [error];
}
