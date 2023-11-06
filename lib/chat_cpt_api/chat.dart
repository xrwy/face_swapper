import 'chat_provider.dart';

class ChatGPT implements ChatApiProvider {
  @override
  String apiKey = "Chat GPT API KEY";

  @override
  String apiUrl = "Chat GPT API URL";

  @override
  Future<String> createCompletion(String prompt) async{
    return "Create Completion";
  }

  @override
  Future<String> createCompletionWithSystem(String prompt) async{
    return "Create Completion With System";
  }

}