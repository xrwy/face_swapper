import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/imgbb.dart';
import 'image_upload_api_provider.dart';


class ImageUpload extends ImageUploadApiProvider {
  @override
  String key = ImgBb().apiKey;

  @override
  Future uploadImageToImg(String? imagePath) async {
    final url = Uri.parse(ImgBb().apiUrl);
    final multiPart = await http.MultipartFile.fromPath('image', imagePath!);

    final request = http.MultipartRequest('POST', url)
      ..fields['key'] = key
      ..fields['expiration'] = "600"
      ..files.add(multiPart);

    http.StreamedResponse uploadImageToImgbbRResponse;

    while (true) {
      uploadImageToImgbbRResponse = await request.send();


      if (uploadImageToImgbbRResponse.statusCode == 200) {
        final responseBody =
            await uploadImageToImgbbRResponse.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        return {
          "url": jsonResponse['data']['url'],
        };
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

}