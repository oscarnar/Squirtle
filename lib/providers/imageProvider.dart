import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:squirtle/models/imageModel.dart';

class ImagenProvider with ChangeNotifier {
  Imagen image;

  //ImageProvider(this.image);
  
  void addImage(Imagen img){
    this.image = img;
  }
  //void addImage(File img){
  //  this.image = Imagen(img);
  //  print("inicio");
  //  this.image.compressFile();
  //  print("fin");
  //}
  void update() => image.update();
}