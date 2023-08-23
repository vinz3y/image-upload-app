import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      String url =
          'https://your-upload-endpoint.com'; // Replace with your API endpoint
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        http.MultipartFile(
          'image',
          _imageFile!.readAsBytes().asStream(),
          _imageFile!.lengthSync(),
          filename: 'image.jpg',
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        // Image uploaded successfully
        print('Image uploaded successfully');
      } else {
        // Error uploading image
        print('Error uploading image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
              ),
            SizedBox(
              width: 100,
              height: 50,
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 400.0,
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(240, 248, 221, 255), // Background color
                ),
                label: Text('Pick Image(JPG/JPEG/PNG)'),
                icon: Image.asset('assets/icons/image.png'),
              ),
            ),
            SizedBox(
              width: 100,
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(240, 248, 221, 255), // Background color
              ),
              label: Text('Pick GIF'),
              icon: Image.asset('assets/icons/gif.png'),
            ),
            SizedBox(
              width: 100,
              height: 20,
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 26, 15, 29), // Background color
              ),
              child: Text('Upload (Image/GIF)'),
            ),
          ],
        ),
      ),
    );
  }
}
