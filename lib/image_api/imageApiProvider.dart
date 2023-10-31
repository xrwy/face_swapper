import '../api_provider.dart';

abstract class ImageApiProvider implements ApiProvider{
  Future<dynamic> createImage(String socialMediaPrompt);
}
