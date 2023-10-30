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
  File? pingImageResult; // initialize null

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

  String selected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            selected = "";
            pingImageResult = null;
          });
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              pingImageResult != null
                  ? Center(
                      child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: FileImage(pingImageResult!),
                              width: 200,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "*Now click on the icon of the media you want to select.",
                            style: TextStyle(color: Colors.red.shade400),
                          )
                        ],
                      ),
                    ))
                  : const Center(
                      child: Image(
                        image: AssetImage("assets/man_with_hair.PNG"),
                        width: 200,
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(26),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child:
                                Image(image: AssetImage("assets/bald_man.PNG")),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Facebook",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selected = "facebook";
                            });
                          },
                          child: const Image(
                            image: AssetImage("assets/facebook.png"),
                            width: 36,
                          ),
                        )
                      ],
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child:
                                Image(image: AssetImage("assets/bald_man.PNG")),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "LinkedIn",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selected = "linkedin";
                            });
                          },
                          child: const Image(
                            image: AssetImage("assets/linkedin.png"),
                            width: 36,
                          ),
                        )
                      ],
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child:
                                Image(image: AssetImage("assets/bald_man.PNG")),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Instagram",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selected = "instagram";
                            });
                          },
                          child: const Image(
                            image: AssetImage("assets/instagram.png"),
                            width: 36,
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Align(
                  alignment: Alignment.center,
                  heightFactor: 1.0,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            )),
                        padding:
                        MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
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
                    ),
                    const SizedBox(width: 30,),
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red.shade400,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            )),
                        padding:
                        MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                              (Set<MaterialState> states) {
                            return const EdgeInsets.only(top: 15, bottom: 15, right: 50, left: 50);
                          },
                        ),
                      ),
                      onPressed: () {
                        selected = "";
                        pingImageResult = null;
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ],)),
              const SizedBox(
                height: 45,
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
                      minimumSize:
                          const Size(double.infinity, 55), //////// HERE
                      side: const BorderSide(width: 2, color: Colors.white12)),
                  onPressed: () {
                    if(pingImageResult != null && selected != "") {
                      // some codes
                    }else {
                      Widget cancelButton = TextButton(
                        child: const Text("Cancel"),
                        onPressed:  () {
                          Navigator.of(context).pop();
                        },
                      );
                      
                      AlertDialog alert = AlertDialog(
                        title: const Text("Warning"),
                        content: const Text("Do not leave fields blank."),
                        actions: [
                          cancelButton,
                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              
              
              const Text("Asenkron işlemler burada yapılacak"),

              const SizedBox(
                height: 60,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
