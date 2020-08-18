import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:squirtle/interface/scanner/utils/points.dart';
import 'package:image/image.dart' as img;
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scidart/numdart.dart';

class Affine {
  img.Image imagen;
  int h, w;
  Array2d A;
  Array2d B;
  Affine(this.imagen, this.A, this.B, this.w, this.h);
}

Future<img.Image> operAffineComp(Affine data) async {
  //img.Image img_output = data.imagen.clone();
  img.Image img_output = img.copyCrop(data.imagen, 0, 0, data.w, data.h);

  int withImage = data.w;
  int heigthImage = data.h;
  int widthImageOri = data.imagen.width;
  int heigthImageOri = data.imagen.height;
  print("$withImage $heigthImage");
  Array2d invA = matrixInverse(data.A);
  print(invA);
  for (int x = 0; x < withImage; x++) {
    for (int y = 0; y < heigthImage; y++) {
      Array tempX = Array([x.toDouble()]);
      Array tempY = Array([y.toDouble()]);
      Array2d Y = Array2d([tempX, tempY]) - data.B;

      Array2d temp = matrixDot(invA, Y);

      int axisX = temp[0][0].toInt();
      int axisY = temp[1][0].toInt();
      if (axisX < widthImageOri &&
          axisY < heigthImageOri &&
          axisX >= 0 &&
          axisY >= 0) {
        img_output[y * withImage + x] =
            data.imagen[axisY * widthImageOri + axisX];
      }
    }
  }
  return img_output;
}

// --------- Intento de paralelizar --------//
class AffinePar {
  img.Image imagen;
  int wStart, hStart;
  int wEnd, hEnd;
  int wNewImage;
  Array2d invA;
  Array2d B;
  AffinePar(this.imagen, this.invA, this.B, this.wStart, this.hStart, this.wEnd,
      this.hEnd, this.wNewImage);
}

Future<Uint32List> operAffinePar(AffinePar data) async {
  Uint32List output = Uint32List(data.imagen.data.length ~/ 2);

  int widthImageOri = data.imagen.width;
  int heigthImageOri = data.imagen.height;
  int conta = 0;
  for (int x = data.wStart; x < data.wEnd; x++) {
    for (int y = data.hStart; y < data.hEnd; y++) {
      Array tempX = Array([x.toDouble()]);
      Array tempY = Array([y.toDouble()]);
      Array2d Y = Array2d([tempX, tempY]) - data.B;

      Array2d temp = matrixDot(data.invA, Y);

      int axisX = temp[0][0].toInt();
      int axisY = temp[1][0].toInt();
      if (axisX < widthImageOri &&
          axisY < heigthImageOri &&
          axisX >= 0 &&
          axisY >= 0) {
        output[conta] = data.imagen[axisY * widthImageOri + axisX];
        conta++;
        //output.add(data.imagen[axisY * widthImageOri + axisX]);
      }
    }
  }
  print("finalice");
  return output;
}

// --------- Intento de paralelizar --------//

Array2d matrixZeros(int fil, int col) {
  Array2d matrix = Array2d.empty();
  for (int i = 0; i < fil; i++) {
    matrix.add(zeros(col));
  }
  return matrix;
}

Array2d getAffine(List<Point> src, List<Point> dst) {
  Array2d A = matrixZeros(6, 6);
  Array2d B = matrixZeros(6, 1);
  Array2d M = matrixZeros(2, 3);

  for (int i = 0; i < 3; i++) {
    A[i][0] = A[i + 3][3] = src[i].px;
    A[i][1] = A[i + 3][4] = src[i].py;

    A[i][2] = A[i + 3][5] = 1;
    B[i][0] = dst[i].px;
    B[i + 3][0] = dst[i].py;
  }
  Array2d invA = matrixInverse(A);
  Array2d X = matrixDot(invA, B);
  int a = 0;
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 3; j++) {
      M[i][j] = X[a][0];
      a++;
    }
  }
  return M;
}

Array2d getA(Array2d M) {
  Array2d A = matrixZeros(2, 2);
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 2; j++) {
      A[i][j] = M[i][j];
    }
  }
  return A;
}

Array2d getB(Array2d M) {
  Array2d B = matrixZeros(2, 1);
  B[0][0] = M[0][2];
  B[1][0] = M[1][2];
  return B;
}

List<Point> realPoints(List<Point> points, double screen, int widthImage) {
  for (int i = 0; i < points.length; i++) {
    double realPointX = (points[i].px * widthImage) / screen;
    double realPointY = (widthImage * points[i].py) / screen;
    points[i].px = realPointX;
    points[i].py = realPointY;
  }
  return points;
}

double distance(Point a, Point b) {
  double x = (a.px - b.px).abs();
  double y = (a.py - b.py).abs();
  double distance = pow(x, 2) + pow(y, 2);
  distance = sqrt(distance);
  return distance;
}

Future<Uint8List> operCrop(
    {img.Image image, List<Point> points, double withScreen}) async {
  print("inicio " + DateTime.now().toString());
  int widthImg = image.width;
  int heightImg = image.height;

  if(widthImg > 1920 || heightImg > 1080){
    image = img.copyResize(image,width: 1920);
    widthImg = image.width;
    heightImg = image.height;
    print("new size $widthImg $heightImg");
  }
  
  points = realPoints(points, withScreen, widthImg);
  double distWidth = distance(points[0], points[1]);
  double distHeigth = distance(points[0], points[2]);
  double newWidth;
  double newHeigth;
  if (distWidth > distHeigth) {
    newWidth = image.width.toDouble() - points[0].px;
    newHeigth = ((distHeigth * newWidth) / distWidth);
    if (newHeigth > image.height - points[0].py)
      newHeigth = image.height.toDouble() - points[0].py;
  } else {
    newHeigth = image.height.toDouble() - points[0].py;
    newWidth = ((distWidth * newHeigth) / distHeigth);
    if (newWidth > image.width - points[0].px)
      newWidth = image.width.toDouble() - points[0].px;
  }

  Point p2 = Point(newWidth, 0);
  Point p3 = Point(0, newHeigth);

  Array2d M =
      getAffine([points[0], points[1], points[2]], [Point(0, 0), p2, p3]);
  Array2d AM = getA(M);
  Array2d BM = getB(M);

  image = await compute(
      operAffineComp, Affine(image, AM, BM, newWidth.toInt(), newHeigth.toInt()));

  //ori = img.copyCrop(ori, 0, 0, newWidth.toInt(), newHeigth.toInt());
  image = img.grayscale(image);
  image = img.smooth(image, 15);
 
  dynamic ima = await ImgProc.adaptiveThreshold(img.encodeJpg(image), 255,
      ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 7, 12);
  //ima = await ImgProc.threshold(ima, 120, 255, ImgProc.threshBinary);
  ima = await ImgProc.bilateralFilter(ima, 10, 5, 10, Core.borderConstant);
  
  //ima = await ImgProc.dilate(ima, [1, 1]);
  //ima = await ImgProc.erode(ima, [1, 1]);
  return ima;
  /*
  File('${directory.path}/$name+"prueba1".jpg').writeAsBytesSync(ima);
  File imagen = File('${directory.path}/$name+"prueba1".jpg');
  ori = img.decodeImage(imagen.readAsBytesSync());
  ori = img.smooth(ori,15 );
  //ori = img.emboss(ori);
  //ori = img.invert(ori);

  //File('${directory.path}/$name.jpg').writeAsBytesSync(ori.data);
  print("inicio write "+DateTime.now().toString());
  //File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
  //Provider.of<ImagenProvider>().image.uint8 = img.encodeJpg(ori);
  print("fin write"+DateTime.now().toString());
  return img.encodeJpg(ori);*/
}

Future<void> operAffine(
    {File imageFile,
    List<List<double>> matrixM,
    String name,
    List<Point> points}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());

  var A = Array2d([
    Array([
      matrixM[0][0],
      matrixM[0][1],
    ]),
    Array([
      matrixM[1][0],
      matrixM[1][1],
    ]),
  ]);
  var B = Array2d(
    [
      Array([matrixM[0][2]]),
      Array([matrixM[1][2]]),
    ],
  );

  Array2d M = getAffine([Point(2, 1), Point(2, 3), Point(4, 5)],
      [Point(3, 1), Point(2, 3), Point(6, 5)]);
  Array2d AM = getA(M);
  Array2d BM = getB(M);

  //ori = await compute(operAffineComp, Affine(ori, AM, BM));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
