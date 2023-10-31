import 'dart:convert';
import 'dart:io';
import 'package:face_swapper/image_api/image_service.dart';
import 'package:face_swapper/image_api/stable_diffusion_api.dart';
import 'package:face_swapper/models/replicate.dart';
import 'package:http/http.dart' as http;

import 'img_upload_api/image_upload.dart';
import 'img_upload_api/img_upload_service.dart';


class Api {
  static ImageService imageService = ImageService(imageApiProvider: StableDiffusionApi());
  static ImageUploadService imageUploadService = ImageUploadService(imageUploadApiProvider: ImageUpload());

  static Map<String, dynamic> uploadImageToImg = {};
  static Future<String> faceSwapper(
      File? pingImageResult, String selectedPrompt) async {
    try {
      Map<String, dynamic> createImageResponse =
          await imageService.createImage(selectedPrompt);

      if (createImageResponse['error'] != null) {
        throw Exception("Error${createImageResponse['error']}");
      } else {
        var uploadImageToImgbb =
            await imageUploadService.imageUpload(pingImageResult!.path);
        Api.uploadImageToImg = uploadImageToImgbb!;

        if ((uploadImageToImgbb['url'] is String &&
            uploadImageToImgbb['url'].toString().startsWith("http") ==
                true)) {
          final body = json.encode({
            "version":
                "9a4298548422074c3f57258c5d544497314ae4112df80d116f0d2109e843d20d",
            "input": {
              "swap_image": Api.uploadImageToImg['url'],
              "target_image": createImageResponse["image_link"]
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
              "Status Code: ${uploadImageToImgbb['status_code']}\n Error: ${uploadImageToImgbb['error']}\n Status Text: ${uploadImageToImgbb['status_txt']}");
        }
      }
    } catch (e) {
      throw Exception(e.toString()).toString().substring(11);
    }
  }
}
