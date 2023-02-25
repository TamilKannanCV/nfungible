part of 'api_cubit.dart';

@immutable
abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoaded extends ApiState {
  final String body;

  ApiLoaded(this.body);
}

class ApiError extends ApiState {}

class ApiFetching extends ApiState {}
