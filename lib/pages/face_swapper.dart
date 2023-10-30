import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class FaceSwapper extends StatefulWidget {
  const FaceSwapper({super.key});

  @override
  State<StatefulWidget> createState() {
    return FaceSwapperState();
  }
}

class FaceSwapperState extends State<FaceSwapper> {

  File? pingImageResult;

  Future selectImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final File imageTemp = File(image.path);
      setState(() => pingImageResult = imageTemp);
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
              child: Image(image: AssetImage("assets/man_with_hair.PNG"), width: 200,),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(26),
              child: const Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child:
                              Image(image: AssetImage("assets/bald_man.PNG")),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Facebook",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("assets/facebook.png"),
                        width: 40,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child:
                              Image(image: AssetImage("assets/bald_man.PNG")),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "LinkedIn",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("assets/linkedin.png"),
                        width: 36,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child:
                              Image(image: AssetImage("assets/bald_man.PNG")),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Instagram",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("assets/instagram.png"),
                        width: 38,
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 35,),
            Align(
                alignment: Alignment.center,
                heightFactor: 1.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blueAccent),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(7.0)),
                        )),
                    padding: MaterialStateProperty.resolveWith<
                        EdgeInsetsGeometry>(
                          (Set<MaterialState> states) {
                        return const EdgeInsets.all(15);
                      },
                    ),
                  ),
                  onPressed: () {
                    selectImage();
                  },
                  child: const Text(
                    'Select Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                )),
            const SizedBox(
              height: 60,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shadowColor: Colors.black87,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    minimumSize: const Size(double.infinity, 55), //////// HERE
                    side: const BorderSide(width: 2, color: Colors.white12)),
                onPressed: () {},
                child: const Text(
                  "Create",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
