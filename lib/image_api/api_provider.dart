abstract class ImageApiKey {
  String apiKey = "";
}
abstract class ImageApiProvider implements ImageApiKey{
  Future<dynamic> createImage(String socialMediaPrompt);
}
