import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class Imagen{
  Uint8List uint8;
  File imageFile;
  String path;
  img.Image imageObjet;

  Imagen(this.imageFile){
    this.path = imageFile.path;
    //this.uint8 = imageFile.readAsBytesSync();
    //compressFile();
  }

  Imagen.fromPath(String path){
    this.path = path;
    this.imageFile = File(path);
  }

  void update(){
    File(this.path).writeAsBytesSync(uint8);
    imageFile = File(path);
  }

  Future<void> compressFile() async {
    var result = await FlutterImageCompress.compressWithFile(
      this.path,
      minWidth: 1920,
      minHeight: 1080,
      quality: 20,
    );
    this.uint8 = result;
    this.imageObjet = img.decodeImage(result);
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 88,
      );

    return result;
  }
}