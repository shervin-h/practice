import 'dart:ui';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final Color lineColor;
  final double thickness;
  final bool fill;
  final Color bgColor;
  final double? distanceFromTipTrapezoid;

  MyPainter({
    required this.lineColor,
    required this.thickness,
    this.fill = false,
    this.bgColor = Colors.transparent,
    this.distanceFromTipTrapezoid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    Paint bgPaint = Paint()
      ..color = bgColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint arrowPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness * 0.3;

    double distance = (distanceFromTipTrapezoid != null &&
            distanceFromTipTrapezoid! > 0 &&
            distanceFromTipTrapezoid! < width)
        ? distanceFromTipTrapezoid!
        : width * 0.7;

    Offset firstPoint = const Offset(0, 0);
    Offset secondPoint = Offset(distance, 0);
    Offset thirdPoint = Offset(width, height * 0.5);
    Offset forthPoint = Offset(distance, height);
    Offset fifthPoint = Offset(0, height);

    canvas.drawPoints(
      PointMode.polygon,
      [
        firstPoint,
        secondPoint,
        thirdPoint,
        forthPoint,
        fifthPoint,
        firstPoint,
      ],
      linePaint,
    );

    if (fill) {
      Path path = Path();
      path.lineTo(firstPoint.dx, firstPoint.dy);
      path.lineTo(secondPoint.dx, secondPoint.dy);
      path.lineTo(thirdPoint.dx, thirdPoint.dy);
      path.lineTo(forthPoint.dx, forthPoint.dy);
      path.lineTo(fifthPoint.dx, fifthPoint.dy);
      path.close();
      canvas.drawPath(path, bgPaint);

      // draw arrow
      canvas.drawPoints(
        PointMode.polygon,
        [
          secondPoint,
          thirdPoint,
          forthPoint,
        ],
        arrowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
