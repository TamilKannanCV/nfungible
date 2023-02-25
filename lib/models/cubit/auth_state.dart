part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoggedIn extends AuthState {
  final String accessToken;

  AuthLoggedIn(this.accessToken);
}

class AuthLoggedOut extends AuthState {}

class AuthLoggingIn extends AuthState {}

class AuthError extends AuthState {}
