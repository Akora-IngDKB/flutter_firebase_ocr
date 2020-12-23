import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File _image;
  String detectedText;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }

    detectText();
  }

  Future<void> detectText() async {
    final visionImage = FirebaseVisionImage.fromFile(_image);

    final recognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await recognizer.processImage(visionImage);

    setState(() {
      detectedText = visionText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            if (_image == null) {
              return Text('No image selected');
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(_image),
                    if (detectedText != null) ...[
                      SizedBox(height: 16),
                      Text(
                        'Detected Text:',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        detectedText,
                        style: TextStyle(height: 1.5, fontSize: 18),
                      ),
                    ],
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_photo_alternate),
        onPressed: () async => pickImage(),
      ),
    );
  }
}
