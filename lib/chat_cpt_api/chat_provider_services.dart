import 'package:face_swapper/chat_cpt_api/chat_provider.dart';

class ChatProviderServices {
  final ChatApiProvider chatApiProvider;

  ChatProviderServices({required this.chatApiProvider});

  Future<dynamic> createCompletion(String prompt) {
    return chatApiProvider.createCompletion(prompt);
  }
}