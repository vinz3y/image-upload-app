import 'package:flutter/material.dart';

import 'file_upload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ImageUploadPage(),
    );
  }
}
