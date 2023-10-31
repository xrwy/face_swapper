import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:face_swapper/image_api/api_provider.dart';
import 'package:face_swapper/models/stabled_diffusion.dart';


class StableDiffusionApi extends ImageApiProvider  {
  @override
  String apiKey = StabledDiffusion().apiUrl;

  @override
  Future<Map<String, dynamic>> createImage(String socialMediaPrompt) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "key": apiKey,
      "prompt": socialMediaPrompt,
      "negative_prompt": null,
      "model_id": "ae-sdxl-v1",
      "panorama": null,
      "self_attention": null,
      "width": "512",
      "guidance": 7.5,
      "height": "512",
      "samples": "1",
      "upscale": null,
      "safety_checker": null,
      "clip_skip": 1,
      "free_u": null,
      "instant_response": null,
      "steps": 20,
      "use_karras_sigmas": null,
      "algorithm_type": null,
      "safety_checker_type": null,
      "tomesd": null,
      "seed": null,
      "webhook": null,
      "track_id": null,
      "scheduler": "DDPMScheduler",
      "base64": null,
      "temp": null,
      "vae": null
    });

    final response = await http.post(
      Uri.parse(apiKey),
      headers: headers,
      body: body,
    );

    var output = jsonDecode(response.body)["output"];
    if (output != null && output.isNotEmpty) {
      return {"image_link": output[0].toString()};
    } else {
      return {'error': jsonDecode(response.body)["message"].toString()};
    }
  }
}
