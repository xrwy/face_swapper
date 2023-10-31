import 'image_upload_api_provider.dart';

class ImageUploadService {
  final ImageUploadApiProvider imageUploadApiProvider;

  ImageUploadService({required this.imageUploadApiProvider});

  Future imageUpload(String socialMediaPrompt) async {
    return imageUploadApiProvider.uploadImageToImg(socialMediaPrompt);
  }
}
