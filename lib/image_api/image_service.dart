import 'imageApiProvider.dart';

class ImageService {
  final ImageApiProvider imageApiProvider;

  ImageService({required this.imageApiProvider});

  Future createImage(String socialMediaPrompt) async {
    return imageApiProvider.createImage(socialMediaPrompt);
  }
}
