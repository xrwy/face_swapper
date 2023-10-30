import 'package:face_swapper/pages/face_swapper.dart';
import 'package:face_swapper/pages/login.dart';
import 'package:face_swapper/pages/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Swapper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FaceSwapper(),
    );
  }
}


/*

Dark Modu
* return MaterialApp(
      title: 'Face Swapper',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
      ),
      home: const FaceSwapper(),
    );
*
* */