import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:squirtle/interface/scanner/algorithms/affine.dart';
import 'package:squirtle/interface/scanner/algorithms/cannyContours.dart';
import 'package:squirtle/interface/scanner/components/rotateImage.dart';
import 'package:squirtle/interface/scanner/components/textRecognition.dart';
import 'package:squirtle/models/imageModel.dart';
import 'package:squirtle/providers/imageProvider.dart';
import 'package:squirtle/interface/scanner/utils/points.dart';
import 'package:squirtle/interface/scanner/utils/pointsPaint.dart';
import 'package:image/image.dart' as imgPack;
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/imgproc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//TODO: mejorar la deteccion de bordes
//      Añadir provider para toda la app
//      Poner TextField para copiar el texto generado

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File _imageFile;
  Uint8List img;
  String path;
  bool isCropImage = false;
  double fixPos = 23;
  bool text = false;
  int indexPoint;
  List<Point> points = [
    Point(100, 100),
    Point(200, 100),
    Point(100, 200),
    Point(200, 200)
  ];
  Icon iconCrop = Icon(
    Icons.arrow_drop_down_circle,
    color: Colors.red[400],
  );

  void updatePoints(dynamic edgePoints) {
    for (int i = 0; i < points.length; i++) {
      points[i] = Point(edgePoints[i * 2], edgePoints[(i * 2) + 1]);
    }
  }

  void edgePointsUpdate(dynamic edgePoints) {
    int widthImage = Provider.of<ImagenProvider>(context, listen: false)
        .image
        .imageObjet
        .width;
    double screen = MediaQuery.of(context).size.width;
    List<Point> pointsCopy = new List<Point>.from(points);
    double minX = double.infinity;
    int index = 0;
    for (int i = 0; i < points.length; i++) {
      double screenPointX = (edgePoints[i * 2] * screen) / widthImage;
      double screenPointY = (screen * edgePoints[(i * 2) + 1]) / widthImage;
      pointsCopy[i].px = screenPointX;
      pointsCopy[i].py = screenPointY;
      double tempMin = pow(screenPointX, 2) + pow(screenPointY, 2);
      if (tempMin < minX) {
        minX = tempMin;
        index = i;
      }
    }
    points[0] = pointsCopy[index];
    points[1] = pointsCopy[(index + 3) % 4];
    points[2] = pointsCopy[(index + 1) % 4];
    points[3] = pointsCopy[(index + 2) % 4];

    print(
        "New points update: ${points[0].px},${points[0].py},${points[1].px},${points[1].py},${points[2].px},${points[2].py},${points[3].px},${points[3].py}");
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected;
    //if (source == ImageSource.gallery) {
    selected = await ImagePicker.pickImage(source: source);
    final directory = await getApplicationDocumentsDirectory();
    path = '${directory.path}/${DateTime.now().toString()}.jpeg';

    Imagen imgTemp = Imagen(selected);
    print(selected.lengthSync());
    if (selected.lengthSync() > 1000000) {
      await imgTemp.compressFile();
      print(imgTemp.uint8.length);
    } else {
      imgTemp.uint8 = selected.readAsBytesSync();
      imgTemp.imageObjet = imgPack.decodeImage(imgTemp.uint8);
    }
    Uint8List edge = new Uint8List.fromList(imgTemp.uint8);
    dynamic edgePoints = await findContours(image: edge, minT: 10, maxT: 50);
    print(edgePoints);

    Provider.of<ImagenProvider>(context, listen: false).addImage(imgTemp);
    edgePointsUpdate(edgePoints);

    setState(() {
      text = false;
      this.img =
          Provider.of<ImagenProvider>(context, listen: false).image.uint8;
      isCropImage = true;
    });
  }

  //TODO: Fix this, add provider
  Future<void> updateImage(Uint8List imgTemp) async {
    Provider.of<ImagenProvider>(context, listen: false).image.uint8 = imgTemp;
    Provider.of<ImagenProvider>(context, listen: false).image.imageObjet =
        imgPack.decodeImage(imgTemp);
    final directory = await getApplicationDocumentsDirectory();
    String name = "${directory.path}/${DateTime.now().toString()}.jpg";
    File(name).writeAsBytesSync(imgTemp);
    Provider.of<ImagenProvider>(context, listen: false).image.imageFile =
        File(name);

    setState(() {
      this.img = imgTemp;
      isCropImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text("CamScanner UNSA"),
      //  centerTitle: true,
      //  actions: [
      //    if (isCropImage == true) ...[
      //      MaterialButton(
      //        child: Text(
      //          "Cancelar",
      //          style: TextStyle(color: Colors.white),
      //        ),
      //        onPressed: () {
      //          setState(() {
      //            isCropImage = false;
      //          });
      //        },
      //      )
      //    ]
      //  ],
      //),
      floatingActionButton: floatingButton(),
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              MaterialButton(
                child: Text("CropImage"),
                onPressed: () {
                  setState(
                    () {
                      if (img != null) {
                        isCropImage = true;
                      }
                    },
                  );
                },
              ),
              MaterialButton(
                child: Text("Extract text"),
                onPressed: () {
                  setState(
                    () {
                      if (img != null) {
                        text = true;
                      }
                    },
                  );
                },
              ),
              MaterialButton(
                child: Text("Canny"),
                onPressed: () {
                  setState(
                    () {
                      if (img != null) {
                        cannyContours(
                          image: img,
                          maxT: 50,
                          minT: 10,
                        ).then((value) => updateImage(value));
                      }
                    },
                  );
                },
              ),
              MaterialButton(
                child: Text("FindContours"),
                onPressed: () {
                  if (img != null) {
                    findContours(
                      image: img,
                    ).then((value) => edgePointsUpdate(value));
                  }
                  setState(
                    () {
                      isCropImage = true;
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          if (this.img != null && isCropImage == false) ...[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Image.memory(
                this.img,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
          if (this.img != null && isCropImage == true) ...[
            cropImage(),
          ],
          if (this.img == null) ...[
            Center(
              child: Text(
                "No hay imagen cargada",
                style: TextStyle(fontSize: 35),
              ),
            )
          ],
          if (text == true) ...[
            TextRecognition(),
          ]
        ],
      ),
    );
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    //print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset =
        box.globalToLocal(details.localPosition); // .globalPosition);
    Point actual = Point(localOffset.dx, localOffset.dy);
    int bestPoint = close(actual, points);
    //print('${actual.px} ${actual.py}');
    setState(() {
      points[bestPoint].px = actual.px;
      points[bestPoint].py = actual.py;
      indexPoint = bestPoint;
    });
  }

  void onDragStart(BuildContext context, DragStartDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.localPosition);
    Point actual = Point(localOffset.dx, localOffset.dy);
    int bestPoint = close(actual, points);
    setState(() {
      points[bestPoint].px = actual.px;
      points[bestPoint].py = actual.py;
      indexPoint = bestPoint;
    });
  }

  void onDrag(BuildContext context, DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.localPosition);
    Point actual = Point(localOffset.dx, localOffset.dy);
    int bestPoint = close(actual, points);
    setState(() {
      points[bestPoint].px = actual.px;
      points[bestPoint].py = actual.py;
      indexPoint = bestPoint;
    });
  }

  Widget cropImageStack() {
    return Stack(
      children: [
        Image.file(_imageFile),
      ],
    );
  }

  Widget cropImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: new GestureDetector(
            onTapDown: (TapDownDetails details) => onTapDown(context, details),
            onPanStart: (DragStartDetails details) =>
                onDragStart(context, details),
            onPanUpdate: (DragUpdateDetails details) =>
                onDrag(context, details),
            child: new Stack(
              //fit: StackFit.loose,
              children: <Widget>[
                // Hack to expand stack to fill all the space. There must be a better
                // way to do it.
                if (this.img != null) ...[
                  Image.memory(
                    this.img,
                    fit: BoxFit.fitWidth,
                  ),
                  CustomPaint(
                    painter: PaintPoints(points),
                  ),
                  //Draggable(
                  //  data: indexPoint,
                  //  child: posPoints(0, points[indexPoint]),
                  //  feedback: null,
                  //)
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget floatingCrop() {
    imgPack.Image imageRot =
        Provider.of<ImagenProvider>(context, listen: false).image.imageObjet;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(Icons.rotate_right),
          mini: true,
          onPressed: () {
            imageRot = rotate(image: imageRot, angle: 90);
            updateImage(imgPack.encodeJpg(imageRot));
            Provider.of<ImagenProvider>(context, listen: false)
                .image
                .imageObjet = imageRot;
            isCropImage = true;
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.rotate_left),
          mini: true,
          onPressed: () {
            imageRot = rotate(image: imageRot, angle: -90);
            updateImage(imgPack.encodeJpg(imageRot));
            Provider.of<ImagenProvider>(context, listen: false)
                .image
                .imageObjet = imageRot;
            isCropImage = true;
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.settings_backup_restore),
          onPressed: () {
            setState(() {
              points[0] = Point(100, 100);
              points[1] = Point(300, 100);
              points[2] = Point(100, 400);
              points[3] = Point(300, 400);
            });
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.crop),
          onPressed: () {
            operCrop(
              image: Provider.of<ImagenProvider>(context, listen: false)
                  .image
                  .imageObjet,
              points: points,
              withScreen: MediaQuery.of(context).size.width,
            ).then(
              (value) {
                updateImage(value);
                points = [
                  Point(100, 100),
                  Point(200, 100),
                  Point(100, 200),
                  Point(200, 200)
                ];
              },
            );
          },
        ),
      ],
    );
  }

  Widget floatingButton() {
    if (isCropImage) {
      return floatingCrop();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "floating2",
          mini: true,
          child: Icon(Icons.camera_alt),
          onPressed: () {
            _pickImage(ImageSource.camera);
          },
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          heroTag: "floating3",
          child: Icon(Icons.image),
          onPressed: () {
            _pickImage(ImageSource.gallery);
          },
        ),
      ],
    );
  }

  Widget posPoints(double fixPos, Point point) {
    return Positioned(
      child: IconButton(
        icon: iconCrop,
        onPressed: () {},
      ),
      left: point.px - fixPos,
      top: point.py - fixPos,
    );
  }
}
