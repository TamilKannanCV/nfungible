import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nfungible/models/upload_file_url.dart';
import 'package:nfungible/utils/string_utils.dart';
import '../configs/graphql_config.dart';
import '../models/nft_model/nft_model.dart';
import '../models/nft_set/nft_set.dart';

class GraphqlService {
  final appID = dotenv.get('NIFTORY_CLIENT_ID');
  static final config = GraphqlConfig();
  final client = config.clientToQuery();

  static final StreamController<NftModel> _controller = StreamController.broadcast();
  static final Stream<NftModel> nftModelStream = _controller.stream;

  static final StreamController<NftSet> _setsController = StreamController.broadcast();
  static final Stream<NftSet> setsStream = _setsController.stream;

  ///Gets all available NFT Models
  Future<void> getNFTModels() async {
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
      _controller.add(nftModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Gets all available NFT sets
  Future<void> getNFTSets() async {
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
      _setsController.add(nftSet);
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Create an NFT set
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

  ///Creates an NFT Model
  Future<bool> createNFTModel({
    required String title,
    required String description,
    required int quantity,
    required File posterImage,
    required File contentImage,
    required String setId,
  }) async {
    final posterUrl = await createFileUploadUrl();
    final contentUrl = await createFileUploadUrl();

    await uploadImageToPreSignedUrl(posterImage, "${posterUrl.url}");
    await uploadImageToPreSignedUrl(contentImage, "${contentUrl.url}");

    try {
      final result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
            mutation CreateModel(\$setId: ID!, \$data: NFTModelCreateInput!) {
                createNFTModel(setId: \$setId, data: \$data) {
                    id
                    quantity
                    title
                }
            }
'''),
          variables: {
            "setId": setId,
            "data": {
              "title": title,
              "description": description,
              "quantity": quantity,
              "content": {
                "fileId": contentUrl.id,
                "posterId": posterUrl.id,
              },
            }
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
      final modelId = res['createNFTModel']['id'];
      log(modelId);
      await mintNFTModel(modelId, quantity);
      getNFTModels();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Uploads image to a pre-signed url
  Future<void> uploadImageToPreSignedUrl(File file, String presignedUrl) async {
    final response = await http.put(
      Uri.parse(presignedUrl),
      headers: {"Content-Type": "image/jpeg"},
      body: await file.readAsBytes(),
    );

    if (response.statusCode == 200) {
      log('File uploaded successfully');
    } else {
      log(response.statusCode.toString());
      log('Failed to upload file');
      throw Exception();
    }
  }

  ///Create a file upload url
  Future<UploadFileUrl> createFileUploadUrl() async {
    try {
      final result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
           mutation CreateFileUploadUrl(\$name: String!, \$description: String, \$options: CreateFileOptionsInput!) {
              createFileUploadUrl(name: \$name, description: \$description, options: \$options) {
                  id
                  name
                  url
                  state
              }
          }
'''),
          variables: {
            "name": StringUtils.getRandomString(10),
            "description": "NFT Model File",
            "options": const {
              "uploadToIPFS": true,
              "contentType": "image/jpeg",
            },
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
      return UploadFileUrl.fromMap(res['createFileUploadUrl']);
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Mints an NFT Model
  Future<void> mintNFTModel(String modelId, int quantityToMint) async {
    try {
      final result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
          mutation mintNFTModel(\$id: ID!, \$quantity: PositiveInt) {
            mintNFTModel(id: \$id, quantity: \$quantity) {
                id
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
            }
          }
'''),
          variables: {
            "id": modelId,
            "quantity": quantityToMint,
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
      log(res.toString());
    } catch (e) {
      throw Exception(e);
    }
  }
}
