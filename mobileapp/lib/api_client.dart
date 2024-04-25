import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const String api = "https://rx-assistant.fly.dev";

class ApiClient {
  Future<RxResponse> analyzeRx(String imagePath) async {
    final uri = Uri.parse("$api/query");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath,
          contentType: MediaType('image', 'jpeg')),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return RxResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to analyze prescription");
    }
  }
}

class RxResponse {
  final String result;

  RxResponse({required this.result});

  factory RxResponse.fromJson(Map<String, dynamic> json) {
    return RxResponse(result: json['result']);
  }
}
