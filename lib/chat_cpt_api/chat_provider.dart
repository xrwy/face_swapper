import '../api_provider.dart';

abstract class ChatApiProvider implements ApiProvider{
  Future<dynamic> createCompletion(String prompt);
}
