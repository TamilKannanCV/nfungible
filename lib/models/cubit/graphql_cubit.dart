import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/models/nft_set/nft_set.dart';
import 'package:nfungible/services/graphql_services.dart';

part 'graphql_state.dart';

class GraphqlCubit extends Cubit<GraphqlState> {
  GraphqlCubit() : super(GraphqlInitial()) {
    _graphqlService = GraphqlService();
  }

  late GraphqlService _graphqlService;

  ///Creates an NFT Set
  void createSet(String title) async {
    emit(GraphqlLoading());
    try {
      final res = await _graphqlService.createSet(title);
      if (res == false) {
        emit(GraphqlError());
        return;
      }
      getNFTSets();
      emit(GraphqlLoaded());
    } catch (e) {
      log(e.toString());
      emit(GraphqlError());
    }
  }

  ///Creates an NFT Model
  void createNFTModel({
    required String title,
    required String description,
    required int quantity,
    required File posterImage,
    required File contentImage,
    required String setId,
  }) async {
    emit(GraphqlLoading());
    try {
      final res = await _graphqlService.createNFTModel(title: title, description: description, quantity: quantity, posterImage: posterImage, contentImage: contentImage, setId: setId);
      if (res == false) {
        emit(GraphqlError());
        return;
      }
      emit(GraphqlLoaded());
    } catch (e) {
      log(e.toString());
      emit(GraphqlError());
    }
  }

  ///Returns a list of NFT Models
  void getNFTModels() async {
    emit(GraphqlLoading());
    try {
      await _graphqlService.getNFTModels();
      emit(GraphqlLoaded());
    } catch (e) {
      log(e.toString());
      emit(GraphqlError());
    }
  }

  void getNFTSets() async {
    try {
      await _graphqlService.getNFTSets();
    } catch (e) {
      log(e.toString());
    }
  }
}
