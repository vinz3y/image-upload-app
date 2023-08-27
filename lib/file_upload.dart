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
        print('Image/GIF uploaded successfully');
      } else {
        // Error uploading image
        print('Error uploading Image/GIF');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 15, 15, 1),
      appBar: AppBar(
        title: Text('Image Upload App',
            style: TextStyle(color: Color.fromARGB(235, 255, 255, 255))),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 35,
            ),
            SizedBox(
                height: 30,
                child: Container(
                  height: 300,
                  width: 300,
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Image Preview",
                    style: TextStyle(
                        fontSize: 18, // Set the font size
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(235, 185, 142, 255)),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            (_imageFile != null)
                ? Image.file(
                    _imageFile!,
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/icons/preview.png', // Path to default image asset
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
            SizedBox(
              width: 100,
              height: 60,
            ),

            //Changing Part
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 105,
                  height: 105,
                  child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius
                        ),
                        backgroundColor: Color.fromARGB(235, 235, 225, 250),
                        padding: EdgeInsets.all(
                            16), // Set padding around the content
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/image.png', // Replace with your image asset
                            width: 35, // Set the image width
                            height: 35, // Set the image height
                          ),
                          SizedBox(
                              height: 8), // Add spacing between image and text
                          Text(
                            'Pick Image',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 36, 20, 65),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(JPG/JPEG/PNG)',
                            style: TextStyle(
                              fontSize: 8,
                              color: const Color.fromARGB(255, 36, 20, 65),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 105,
                  height: 105,
                  child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius
                        ),
                        backgroundColor: Color.fromARGB(235, 235, 225, 250),
                        padding: EdgeInsets.all(
                            16), // Set padding around the content
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/gif.png', // Replace with your image asset
                            width: 35, // Set the image width
                            height: 35, // Set the image height
                          ),
                          SizedBox(
                              height: 8), // Add spacing between image and text
                          Text(
                            'Pick GIF',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 36, 20, 65),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(GIF)',
                            style: TextStyle(
                              fontSize: 8,
                              color: const Color.fromARGB(255, 36, 20, 65),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            SizedBox(
              width: 100,
              height: 20,
            ),

            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                ),
                fixedSize: Size(125, 45),
                backgroundColor:
                    Color.fromARGB(235, 122, 39, 255), // Background color
              ),
              child: Column(children: [
                SizedBox(height: 5),
                Text('Upload'),
                Text('(Image/GIF)')
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
