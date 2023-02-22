import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/services/api_service.dart';
import 'package:nfungible/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    _authService = AuthService();
  }

  late AuthService _authService;

  void login() async {
    emit(AuthLoggingIn());
    try {
      final user = await _authService.login();
      final idToken = await _authService.fetchAuthToken(user);
      if (user != null && idToken != null) {
        await ApiService().authenticate(idToken);
        emit(AuthLoggedIn(idToken, user));
        return;
      }
      emit(AuthInitial());
    } catch (e) {
      log(e.toString());
      emit(AuthError());
    }
  }
}
