import 'package:flutter/material.dart';

class SnapToGridExample extends StatefulWidget {
  const SnapToGridExample({super.key});

  @override
  _SnapToGridExampleState createState() => _SnapToGridExampleState();
}

class _SnapToGridExampleState extends State<SnapToGridExample> {
  double unitSize = 50; // اندازه هر خانه گرید (پیکسل)
  double widgetUnits = 2; // اندازه ویجت بر حسب خانه
  double x = 0;
  double y = 0;

  double startX = 0;
  double startY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // نمایش گرید برای دید بهتر
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(unitSize: unitSize),
          ),

          Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              onPanStart: (details) {
                startX = x;
                startY = y;
              },
              onPanUpdate: (details) {
                setState(() {
                  x += details.delta.dx;
                  y += details.delta.dy;
                });
              },
              onPanEnd: (details) {
                setState(() {
                  // اسنپ به نزدیک‌ترین خانه گرید
                  x = (x / unitSize).round() * unitSize;
                  y = (y / unitSize).round() * unitSize;
                });
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
                    "Widget",
                    style: TextStyle(color: Colors.white),
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
