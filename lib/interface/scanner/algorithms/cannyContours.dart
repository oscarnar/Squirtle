import 'dart:typed_data';

import 'package:opencv/core/core.dart';
import 'package:opencv/core/imgproc.dart';

Future<Uint8List> cannyContours(
    {Uint8List image, double minT, double maxT}) async {
  dynamic ima = await ImgProc.cvtColor(image, ImgProc.colorBGR2GRAY);
  
  ima = await ImgProc.gaussianBlur(ima, [5.0,5.0],0);
  //ima = await ImgProc.bilateralFilter(ima, 9, 75, 75, Core.borderConstant);

  //ima = await ImgProc.adaptiveThreshold(ima, 255, ImgProc.adaptiveThreshGaussianC, ImgProc.threshBinary, 7, 15);
  //ima = await ImgProc.medianBlur(ima, 5);
  //ima = await ImgProc.adaptiveThreshold(ima, 255,
  //    ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 7, 14);
  ima = await ImgProc.canny(ima, minT, maxT);
  //ima = await ImgProc.threshold(ima, 120, 255, ImgProc.threshBinary);

  //ima = await ImgProc.dilate(ima, [1, 1]);
  //ima = await ImgProc.erode(ima, [1, 1]);
  return ima;
}

Future<dynamic> findContours({Uint8List image, double minT, double maxT}) async {
  
  Uint8List ima = await cannyContours(image: image,minT: minT, maxT: maxT);
  dynamic edges = await ImgProc.onlyFindContours(ima);
  return edges;
}
