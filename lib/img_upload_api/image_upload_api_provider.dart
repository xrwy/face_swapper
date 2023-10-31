abstract class ImageUploadApiKey {
  String key = "";
}
abstract class ImageUploadApiProvider implements ImageUploadApiKey {
  Future<dynamic> uploadImageToImg(String? imagePath);
}