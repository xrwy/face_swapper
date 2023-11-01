import 'package:face_swapper/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

import 'package:face_swapper/prompts/prompts.dart' as prompts;

class PhotoMerger extends StatefulWidget {
  const PhotoMerger({super.key});

  @override
  State<StatefulWidget> createState() {
    return PhotoMergerState();
  }
}

class PhotoMergerState extends State<PhotoMerger> {
  File? pingImageResult; // initialize null
  String selected = "";
  String selectedImage = "";
  String responseImage = "";

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

  circularProgressIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 60.0),
      child: const CircularProgressIndicator(),
    );
  }

  snapShotHasError(snapshot) {
    return Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 35.0, right: 29.0, left: 29.0),
          padding: const EdgeInsets.only(
              top: 20.0, right: 45.0, bottom: 20.0, left: 45.0),
          decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Container(
            margin: null,
            child: Column(
              children: [
                const Text(
                  'Error',
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${snapshot.error}',
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                )
              ],
            ),
          ),
        ));
  }

  tappedButton(String responseImageParam) async {
    await Future.delayed(const Duration(seconds: 0));

    setState(() {
      selected = "";
      pingImageResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 1, 1, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 1, 1, 0),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Photo Merger",
              style: GoogleFonts.aclonica(fontSize: 28, color: Colors.white),
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 16, top: 5),
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.grey.shade800),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: const Icon(
              IconData(0xe491, fontFamily: 'MaterialIcons'),
              color: Colors.white,
            ),
          ),
        ],
        toolbarHeight: 82,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            selected = "";
            pingImageResult = null;
            selectedImage = "";
          });
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Select Style",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                "Optional",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                                size: 13,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade400,
                          ),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                              )),
                          padding: MaterialStateProperty.resolveWith<
                              EdgeInsetsGeometry>(
                                (Set<MaterialState> states) {
                              return const EdgeInsets.only(
                                  top: 15, bottom: 15, right: 50, left: 50);
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selected = "";
                            pingImageResult = null;
                          });
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
                    ],
                  )),
              pingImageResult != null
                  ? Container(
                margin: const EdgeInsets.all(50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: FileImage(pingImageResult!),
                  ),
                ),
              )
                  : const SizedBox(
                height: 0,
              ),
              pingImageResult == null
                  ? const SizedBox(
                height: 50,
              )
                  : const SizedBox(
                height: 0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: pingImageResult == null || selected == ""
                          ? const Color.fromRGBO(59, 42, 94, 1)
                          : const Color.fromRGBO(120, 82, 185, 1),
                      shadowColor: Colors.black87,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      minimumSize:
                      const Size(double.infinity, 65), //////// HERE
                      side: const BorderSide(
                          width: 2, color: Color.fromRGBO(59, 42, 94, 1))),
                  onPressed: () async {
                    if (pingImageResult != null &&
                        selected != "") {
                    } else {
                      Widget cancelButton = TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
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
              pingImageResult != null &&
                  selected != ""
                  ? FutureBuilder<String>(
                  future: Api.faceSwapper(pingImageResult, "selectedPrompt"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 80.0),
                          child: circularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Align(
                          alignment: Alignment.center,
                          child: snapShotHasError(snapshot));
                    } else if (!snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.only(
                            top: 12, right: 30, bottom: 12, left: 30),
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 2, color: Colors.red)),
                        child: Text(
                          "No Data",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade400),
                        ),
                      );
                    } else if (snapshot.data!.endsWith(".png") ||
                        snapshot.data!.endsWith(".jpg") ||
                        snapshot.data!.endsWith(".bmp") ||
                        snapshot.data!.endsWith(".psd") ||
                        snapshot.data!.endsWith(".jpeg")) {
                      responseImage = snapshot.data!;

                      tappedButton(responseImage);

                      return const SizedBox();
                    } else {
                      return const Align(
                          alignment: Alignment.center,
                          child: Text("Error"));
                    }
                  })
                  : const SizedBox(),
              responseImage != ""
                  ? Container(
                  padding: const EdgeInsets.all(18.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(top: 40.0),
                        child: Image.network(
                          responseImage,
                        ),
                      )))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
