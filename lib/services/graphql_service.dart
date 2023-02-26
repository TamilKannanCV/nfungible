import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../configs/graphql_config.dart';
import '../models/nft_model/nft_model.dart';
import '../models/nft_set/nft_set.dart';

class GraphqlService {
  final appID = dotenv.get('NIFTORY_CLIENT_ID');
  static final config = GraphqlConfig();
  final client = config.clientToQuery();

  Future<NftModel> getNFTModels() async {
    try {
      final result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
            query nftModels(\$appId: ID) {
              nftModels(appId: \$appId, maxResults: 50) {
                items {
                  id
                  blockchainId
                  title
                  description
                  quantity
                  quantityMinted
                  nfts {
                    blockchainState
                    id
                    blockchainId
                    serialNumber
                    transactions {
                        blockchain
                        hash
                        name
                    }
                  }
                  status
                  rarity
                  content {
                    files {
                      url
                      contentType
                    }
                    poster {
                      url
                    }
                  }
                }
                cursor
              }
            }
'''),
          variables: {
            "appId": appID,
          },
        ),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      final res = result.data;
      if (res == null) {
        throw Exception("");
      }
      final nftModel = NftModel.fromMap(res['nftModels']);
      return nftModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NftSet> getNFTSets() async {
    try {
      final result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
            query sets(
                \$appId: ID
              ) {
                sets(
                  appId: \$appId
                ) {
                  createdAt
                  id
                  image                  
                  state
                  status
                  title
                  updatedAt
                }
              }
'''),
          variables: {
            "appId": appID,
          },
        ),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      final res = result.data;
      if (res == null) {
        throw Exception("");
      }
      final nftSet = NftSet.fromMap(res);
      return nftSet;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> createSet(String title) async {
    try {
      final result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
            mutation CreateSet(\$data: NFTSetCreateInput!) {
              createNFTSet(data: \$data) {
                  id
                  title
                  attributes
              }
          }
'''),
          variables: {
            "data": {"title": title},
          },
        ),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      final res = result.data;
      if (res == null) {
        throw Exception("");
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
