part of 'graphql_cubit.dart';

@immutable
abstract class GraphqlState {}

class GraphqlInitial extends GraphqlState {}

class GraphqlLoading extends GraphqlState {}

class GraphqlLoaded<T> extends GraphqlState {
  final T? data;

  GraphqlLoaded({this.data});
}

class GraphqlError extends GraphqlState {}
