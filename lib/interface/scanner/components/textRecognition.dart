import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:squirtle/providers/imageProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TextRecognition extends StatefulWidget {
  @override
  _TextRecognitionState createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  Uint8List imageData;
  File image;
  var text = '';
  bool isText = false;

  Future<void> updateData() async {
    imageData = Provider.of<ImagenProvider>(context, listen: false).image.uint8;
    final directory = await getApplicationDocumentsDirectory();
    String name = "${directory.path}/${DateTime.now().toString()}.jpg";
    File(name).writeAsBytesSync(imageData);
    image = File(name);
  }

  Future pickImage() async {
    if (isText) {
      return;
    }
    await updateData();

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            text = text + word.text + ' ';
            isText = true;
          });
        }
        text = text + '\n';
      }
    }
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    pickImage();
    return Center(
      child: text == ''
          ? Text('El texto aparecerá aquí :)')
          : Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    text,
                  ),
                ),
              ),
            ),
    );
  }
}
