import 'package:flutter/material.dart';

class MultiSnapGridExample extends StatefulWidget {
  const MultiSnapGridExample({super.key});

  @override
  _MultiSnapGridExampleState createState() => _MultiSnapGridExampleState();
}

class _MultiSnapGridExampleState extends State<MultiSnapGridExample> {
  double unitSize = 50; // اندازه هر خانه گرید
  double widgetUnits = 2; // اندازه ویجت بر حسب خانه

  List<Offset> widgetPositions = [
    Offset(0, 0),
    Offset(150, 0),
    Offset(0, 150),
  ];

  int? draggingIndex;

  bool isPositionFree(Offset newPos, int index) {
    for (int i = 0; i < widgetPositions.length; i++) {
      if (i != index && widgetPositions[i] == newPos) {
        return false; // خانه توسط ویجت دیگر اشغال شده
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // کشیدن گرید
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(unitSize: unitSize),
          ),

          // رسم همه ویجت‌ها
          for (int i = 0; i < widgetPositions.length; i++)
            Positioned(
              left: widgetPositions[i].dx,
              top: widgetPositions[i].dy,
              child: GestureDetector(
                onPanStart: (_) {
                  draggingIndex = i;
                },
                onPanUpdate: (details) {
                  setState(() {
                    widgetPositions[i] += details.delta;
                  });
                },
                onPanEnd: (_) {
                  if (draggingIndex != null) {
                    setState(() {
                      double snappedX = (widgetPositions[i].dx / unitSize).round() * unitSize;
                      double snappedY = (widgetPositions[i].dy / unitSize).round() * unitSize;

                      Offset snappedPos = Offset(snappedX, snappedY);

                      // اگه خانه آزاد بود اسنپ کن
                      if (isPositionFree(snappedPos, i)) {
                        widgetPositions[i] = snappedPos;
                      } else {
                        // برگرد به جای قبلی
                        widgetPositions[i] = Offset((widgetPositions[i].dx / unitSize).floor() * unitSize,
                            (widgetPositions[i].dy / unitSize).floor() * unitSize);
                      }
                    });
                  }
                  draggingIndex = null;
                },
                child: Container(
                  width: widgetUnits * unitSize,
                  height: widgetUnits * unitSize,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Widget $i",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double unitSize;

  GridPainter({required this.unitSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += unitSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += unitSize) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
