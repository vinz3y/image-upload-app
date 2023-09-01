import 'dart:io';
//Connect to ESP32 using BLE
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_upload_app/settings.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (await isImage(imageFile)) {
        setState(() {
          _imageFile = imageFile;
        });
      } else {
        _showFormatErrorSnackBar("Only JPG/JPEG/PNG formats are allowed.");
      }
    }
  }

  Future<void> _pickGIF(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (await isGif(imageFile)) {
        setState(() {
          _imageFile = imageFile;
        });
      } else {
        _showFormatErrorSnackBar("Only GIF format is allowed.");
      }
    }
  }

  Future<bool> isImage(File file) async {
    final image = XFile(file.path);
    final size = await image.length();
    final firstBytes = await image.readAsBytes();

    // Check for JPG/JPEG/PNG magic numbers or extensions
    // For example, JPG: 0xFF 0xD8, JPEG: 0xFF 0xD8 0xFF, PNG: 0x89 0x50 0x4E 0x47 0x0D 0x0A 0x1A 0x0A
    if (size < 12 ||
            (firstBytes[0] == 0xFF && firstBytes[1] == 0xD8) || // JPG/JPEG
            (firstBytes[0] == 0x89 &&
                firstBytes[1] == 0x50 &&
                firstBytes[2] == 0x4E &&
                firstBytes[3] == 0x47) // PNG
        ) {
      return true; // Is an image
    }
    return false; // Not an image
  }

  Future<bool> isGif(File file) async {
    final image = XFile(file.path);
    final size = await image.length();
    final firstBytes = await image.readAsBytes();

    if (size < 12 ||
        firstBytes[0] != 0x47 ||
        firstBytes[1] != 0x49 ||
        firstBytes[2] != 0x46) {
      return false; // Not a GIF
    }
    return true; // Is a GIF
  }

  void _showFormatErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
      backgroundColor: const Color.fromRGBO(15, 15, 15, 1),
      appBar: AppBar(
        title: const Text('Image Upload App',
            style: TextStyle(color: Color.fromARGB(235, 255, 255, 255))),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'settings') {
                // Handle option 1
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                )
              ];
            },
          ),
        ],
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
            const SizedBox(
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
                        backgroundColor:
                            const Color.fromARGB(235, 235, 225, 250),
                        padding: const EdgeInsets.all(
                            16), // Set padding around the content
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/image.png', // Replace with your image asset
                            width: 35, // Set the image width
                            height: 35, // Set the image height
                          ),
                          const SizedBox(
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
                      onPressed: () => _pickGIF(ImageSource.gallery),
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
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 36, 20, 65),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
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
            const SizedBox(
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
                fixedSize: const Size(125, 45),
                backgroundColor:
                    const Color.fromARGB(235, 122, 39, 255), // Background color
              ),
              child: const Column(children: [
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
