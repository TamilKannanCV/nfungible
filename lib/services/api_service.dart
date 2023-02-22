import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class ApiService {
  final _authUrl = "https://graphql.api.staging.niftory.com";

  Future<void> authenticate(String idToken) async {
    final client = RetryClient(http.Client());
    final response = await client.get(Uri.parse(_authUrl), headers: {
      "X-Niftory-API-Key": dotenv.env['NIFTORY_API_KEY'].toString(),
      "Authorization": "Bearer $idToken",
    });
    log(response.statusCode.toString());
  }
}
