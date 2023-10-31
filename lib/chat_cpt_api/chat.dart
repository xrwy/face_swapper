import 'chat_provider.dart';

class Chat implements ChatApiProvider {
  @override
  String apiKey = "Chat GPT API KEY";

  @override
  String apiUrl = "Chat GPT API URL";


  @override
  Future createCompletion(String prompt) async{
    return "dwde";
  }

}