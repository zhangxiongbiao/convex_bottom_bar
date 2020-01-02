import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'convex_shape.dart';
import 'reused_gradient.dart';

class ConvexPainter extends CustomPainter {
  final _paint = Paint();
  final _shadowPaint = Paint();
  final _shape = ConvexNotchedRectangle();
  final ReusedGradient _gradient = ReusedGradient();
  final double width;
  final double height;
  final double top;
  final Animation<double> leftPercent;

  ConvexPainter({
    this.top,
    this.width,
    this.height,
    this.leftPercent = const AlwaysStoppedAnimation<double>(0.5),
    Color color = Colors.white,
    Color shadowColor = Colors.black38,
    double sigma = 2,
    Gradient gradient,
  }) : super(repaint: leftPercent) {
    _paint..color = color;
    _shadowPaint
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, sigma);
    _gradient.gradient = gradient;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect host = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect guest = Rect.fromLTWH(
        size.width * leftPercent.value - width / 2, top, width, height);
    _gradient.updateWith(_paint, size: host);
    Path path = _shape.getOuterPath(host, guest);
    canvas.drawPath(path, _shadowPaint);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(ConvexPainter oldDelegate) {
    return oldDelegate.leftPercent.value != leftPercent.value ||
        oldDelegate._paint != _paint;
  }
}
