import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/services/api_service.dart';

part 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(ApiInitial()) {
    _apiService = ApiService();
  }
  late ApiService _apiService;

  void fetchDrops(String idToken) async {
    // _apiService.fetchDrops(idToken);
  }
}
