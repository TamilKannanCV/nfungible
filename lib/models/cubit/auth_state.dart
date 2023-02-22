part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoggedIn extends AuthState {
  final String authToken;
  final User user;

  AuthLoggedIn(this.authToken, this.user);
}

class AuthLoggedOut extends AuthState {}

class AuthLoggingIn extends AuthState {}

class AuthError extends AuthState {}
