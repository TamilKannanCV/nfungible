import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

enum ImageQuality {
  x256,
  x512,
  x1024,
}

class OpenAIServices {
  Future<List<String>> generateAIImages(String query, {int? count, ImageQuality? quality}) async {
    String getSizeFromEnum(ImageQuality quality) {
      switch (quality) {
        case ImageQuality.x256:
          return "256x256";
        case ImageQuality.x512:
          return "512x512";
        case ImageQuality.x1024:
          return "1024x1024";
        default:
          return "";
      }
    }

    final apiKey = dotenv.get("OPENAI_API_KEY");
    final url = dotenv.get("OPENAI_IMG_GEN_URL");

    try {
      final client = RetryClient(http.Client());
      final response = await client.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: json.encode(
          {
            "prompt": query,
            "n": count ?? 5,
            "size": getSizeFromEnum(quality ?? ImageQuality.x512),
          },
        ),
      );
      log(response.body);

      final res = json.decode(response.body);
      final urls = (res['data'] as List<dynamic>);
      return urls.map((e) => e['url']).toList().cast<String>();
    } catch (e) {
      throw Exception(e);
    }
  }
}
