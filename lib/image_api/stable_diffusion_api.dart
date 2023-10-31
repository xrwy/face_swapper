import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:face_swapper/models/stabled_diffusion.dart';

import 'imageApiProvider.dart';

class StableDiffusionApi extends ImageApiProvider {
  @override
  String apiKey = StabledDiffusion().apiKey;

  @override
  String apiUrl = StabledDiffusion().apiUrl;

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

    while (true) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (jsonDecode(response.body)["status"] == "success") {
        var output = jsonDecode(response.body)["output"];
        if (output != null && output.isNotEmpty) {
          return {"image_link": output[0].toString()};
        } else {
          return {'error': jsonDecode(response.body)["message"].toString()};
        }
      }else if (jsonDecode(response.body)["status"] == "error") {
        return {'error': jsonDecode(response.body)["message"].toString()};
      }
    }
  }
}
