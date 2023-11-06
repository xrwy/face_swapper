import '../api_provider.dart';

abstract class ChatApiProvider implements ApiProvider{
  Future<String> createCompletion(String prompt);
  Future<String> createCompletionWithSystem(String prompt);
}
