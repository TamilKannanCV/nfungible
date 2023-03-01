import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/services/openai_services.dart';

part 'openai_state.dart';

class OpenAICubit extends Cubit<OpenAIState> {
  late OpenAIServices _aiServices;

  OpenAICubit() : super(OpenAIInitial()) {
    _aiServices = OpenAIServices();
  }

  List<String>? lastFetchedUrls;
  String? lastRequestQuery;

  void generateAIImages(
    String query, {
    int? count,
    ImageQuality? quality,
  }) async {
    emit(OpenAILoading());
    if (lastRequestQuery.toString() == query.toString()) {
      emit(OpenAILoaded(lastFetchedUrls!));
      return;
    }
    try {
      final urls = await _aiServices.generateAIImages(
        query,
        quality: quality,
        count: count,
      );
      lastRequestQuery = query;
      lastFetchedUrls = urls;
      emit(OpenAILoaded(urls));
    } catch (e) {
      emit(OpenAIError());
    }
  }
}
