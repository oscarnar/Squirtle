import 'package:flutter/material.dart';
import 'package:squirtle/interface/scanner/utils/points.dart';
import 'dart:ui' as ui;

class PaintPoints extends CustomPainter {
  List<Point> points;
  PaintPoints(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.points;
    final pointsPaint = [
      Offset(points[0].px, points[0].py),
      Offset(points[1].px, points[1].py),
      Offset(points[2].px, points[2].py),
      Offset(points[3].px, points[3].py),
    ];
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final paintPoint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, pointsPaint, paintPoint);
    canvas.drawLine(pointsPaint[0], pointsPaint[1], paint);
    canvas.drawLine(pointsPaint[0], pointsPaint[2], paint);
    canvas.drawLine(pointsPaint[1], pointsPaint[3], paint);
    canvas.drawLine(pointsPaint[2], pointsPaint[3], paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
