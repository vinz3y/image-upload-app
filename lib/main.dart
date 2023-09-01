import 'package:flutter/material.dart';
import 'package:image_upload_app/app_preferences.dart';

import 'file_upload.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
