import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:face_swapper/models/replicate.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/imgbb.dart';

class Api {
  static Future<void> imageFromUserRequest() async {}

  static Future<Map<String, dynamic>?> uploadImageToImgbb(
      String? imagePath) async {
    final url = Uri.parse(ImgBb().apiUrl);
    final multiPart = await http.MultipartFile.fromPath('image', imagePath!);

    final request = http.MultipartRequest('POST', url)
      ..fields['key'] = ImgBb().apiKey
      ..fields['expiration'] = "600"
      ..files.add(multiPart);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      return {
        "url": jsonResponse['data']['url'],
      };
    } else {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      return {
        "status_code": jsonResponse['status_code'],
        "error": jsonResponse['error']['message'],
        "status_txt": jsonResponse['status_txt'],
      };
    }
  }

  static Future<File> assetImageToFile(
      String assetPath, String fileName) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    final File file = File('$tempPath/$fileName');
    await file.writeAsBytes(data.buffer.asUint8List());

    return file;
  }

  static Map<String, dynamic> response = {};
  static Map<String, dynamic> response_2 = {};

  static Future<String> faceSwapper(
      File? pingImageResult, String selectedImage) async {
    try {
      var file =
          await assetImageToFile(selectedImage, selectedImage.split("/")[1]);

      var response = await Api.uploadImageToImgbb(pingImageResult!.path);
      var response_2 = await Api.uploadImageToImgbb(file.path);

      Api.response = response!;
      Api.response_2 = response_2!;

      if ((response != null && response['url'] is String) &&
          (response_2 != null && response_2['url'] is String)) {
        final body = json.encode({
          "version":
              "9a4298548422074c3f57258c5d544497314ae4112df80d116f0d2109e843d20d",
          "input": {
            "swap_image": Api.response['url'],
            "target_image": Api.response_2['url']
          },
        });

        final headers = {
          "Content-Type": "application/json",
          "Authorization": "Token ${Replicate().apiToken}"
        };

        final postResponse = await http.post(Uri.parse(Replicate().apiUrl),
            body: body, headers: headers);

        if (postResponse.statusCode == 201) {
          final predictionId = json.decode(postResponse.body)['id'];
          final getUrl = "${Replicate().apiUrl}/$predictionId";

          while (true) {
            final checkResponse =
                await http.get(Uri.parse(getUrl), headers: headers);
            final status = json.decode(checkResponse.body)['status'];

            if (status == "succeeded") {
              final imageUrl = json.decode(checkResponse.body)['output'];
              if (imageUrl is List) {
                return imageUrl[0];
              } else {
                return imageUrl;
              }
            } else if (status == "failed") {
              throw Exception("An error occurred while loading the image.");
            }
            await Future.delayed(const Duration(seconds: 2));
          }
        } else {
          throw Exception(
              "The request failed. Status code: ${postResponse.statusCode}");
        }
      } else {
        throw Exception(
            "Status Code: ${response?['status_code']}\n Error: ${response?['error']}\n Status Text: ${response?['status_txt']}");
      }
    } catch (e) {
      throw Exception(e.toString()).toString().substring(11);
    }
  }
}
