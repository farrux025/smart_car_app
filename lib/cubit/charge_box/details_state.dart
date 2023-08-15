part of 'details_cubit.dart';

@immutable
abstract class DetailsState extends Equatable {}

class DetailsInitial extends DetailsState {
  @override
  List<Object?> get props => [];
}

class DetailsLoaded extends DetailsState {
  PublicDetails details;

  DetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class DetailsError extends DetailsState {
  String error;

  DetailsError(this.error);

  @override
  List<Object?> get props => [error];
}
