import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter(this.colorFrom, this.colorTo);

  final Color colorFrom;
  final Color colorTo;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;
    paint.shader = ui.Gradient.linear(const Offset(0, 0),
        Offset(size.width, size.height), [colorFrom, colorTo]);

    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height * 1.1, size.width, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
