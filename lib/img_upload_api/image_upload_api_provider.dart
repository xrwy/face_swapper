import 'package:face_swapper/api_provider.dart';

abstract class ImageUploadApiProvider implements ApiProvider {
  Future<dynamic> uploadImageToImg(String? imagePath);
}