import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:face_swapper/models/replicate.dart';
import 'package:face_swapper/models/stabled_diffusion.dart';
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

    var uploadImageToImgbbRResponse;

    while (true) {
      try {
        uploadImageToImgbbRResponse = await request.send();

        if (uploadImageToImgbbRResponse.statusCode == 200) {
          final responseBody = await uploadImageToImgbbRResponse.stream.bytesToString();
          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

          return {
            "url": jsonResponse['data']['url'],
          };
        }
      }catch (e) {
        return {
          "status_code": uploadImageToImgbbRResponse['status_code'],
          "error": uploadImageToImgbbRResponse['error']['message'],
          "status_txt": uploadImageToImgbbRResponse['status_txt'],
        };
      }


      await Future.delayed(const Duration(seconds: 2));
    }


  }

  /*static Future<File> assetImageToFile(
      String assetPath, String fileName) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    final File file = File('$tempPath/$fileName');
    await file.writeAsBytes(data.buffer.asUint8List());

    return file;
  }*/

  static Future<dynamic> createImage(String socialMediaPrompt) async {
    String url = StabledDiffusion().apiUrl;
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "key": StabledDiffusion().apiKey,
      "prompt": socialMediaPrompt,
      "negative_prompt": null,
      "model_id": "ae-sdxl-v1",
      "panorama": null,
      "self_attention": null,
      "width": "512",
      "guidance": 7.5,
      "height": "512",
      "samples": "1",
      "upscale": null,
      "safety_checker": null,
      "clip_skip": 1,
      "free_u": null,
      "instant_response": null,
      "steps": 20,
      "use_karras_sigmas": null,
      "algorithm_type": null,
      "safety_checker_type": null,
      "tomesd": null,
      "seed": null,
      "webhook": null,
      "track_id": null,
      "scheduler": "DDPMScheduler",
      "base64": null,
      "temp": null,
      "vae": null
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    var output = jsonDecode(response.body)["output"];
    if (output != null && output.isNotEmpty) {
      return {"image_link": output[0]};
    } else {
      return {'error': response.reasonPhrase};
    }
  }

  static Map<String, dynamic> createImageResponse = {};
  static Map<String, dynamic> uploadImageToImgbb_1 = {};
  static Map<String, dynamic> uploadImageToImgbb_2 = {};

  static Future<String> faceSwapper(
      File? pingImageResult, String selectedPrompt) async {
    try {
      Map<String, dynamic> createImageResponse =
          await createImage(selectedPrompt);

      if (createImageResponse != null &&
          createImageResponse!['error'] != null) {
        throw Exception("Error${createImageResponse!['error']}");
      } else {
        var uploadImageToImgbb_2 =
            await Api.uploadImageToImgbb(pingImageResult!.path);

        Api.createImageResponse = createImageResponse;

        Api.uploadImageToImgbb_1 = uploadImageToImgbb_1!;
        Api.uploadImageToImgbb_2 = uploadImageToImgbb_2!;

        if ((uploadImageToImgbb_1 != null &&
                uploadImageToImgbb_1?['url'] is String &&
                uploadImageToImgbb_1?['url'].toString().startsWith("http") ==
                    true) &&
            (uploadImageToImgbb_2 != null &&
                uploadImageToImgbb_2?['url'] is String &&
                uploadImageToImgbb_2?['url'].toString().startsWith("http") ==
                    true)) {
          print("Hata2");
          final body = json.encode({
            "version":
                "9a4298548422074c3f57258c5d544497314ae4112df80d116f0d2109e843d20d",
            "input": {
              "swap_image": createImageResponse[
                  "image_link"], //Api.uploadImageToImgbb_1['url'],
              "target_image": Api.uploadImageToImgbb_2?[
                  'url'] // Kullanıcının kendi fotoğrafı, yüzü
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
          if ((uploadImageToImgbb_1 != null &&
              uploadImageToImgbb_1?['url'] is String &&
              uploadImageToImgbb_1?['url'].toString().startsWith("http") ==
                  true)) {
            throw Exception(
                "Status Code: ${uploadImageToImgbb_1?['status_code']}\n Error: ${uploadImageToImgbb_1?['error']}\n Status Text: ${uploadImageToImgbb_1?['status_txt']}");
          } else if ((uploadImageToImgbb_2 != null &&
              uploadImageToImgbb_2?['url'] is String &&
              uploadImageToImgbb_2?['url'].toString().startsWith("http") ==
                  true)) {
            throw Exception(
                "Status Code: ${uploadImageToImgbb_2?['status_code']}\n Error: ${uploadImageToImgbb_2?['error']}\n Status Text: ${uploadImageToImgbb_2?['status_txt']}");
          } else {
            throw Exception("Error");
          }
        }
      }
    } catch (e) {
      throw Exception(e.toString()).toString().substring(11);
    }
  }
}
