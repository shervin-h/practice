import 'package:flutter/material.dart';

class DynamicSnapGridExample extends StatefulWidget {
  const DynamicSnapGridExample({super.key});

  @override
  _DynamicSnapGridExampleState createState() => _DynamicSnapGridExampleState();
}

class _DynamicSnapGridExampleState extends State<DynamicSnapGridExample> {
  double unitSize = 60; // اندازه هر خانه گرید (پیکسل)
  double widgetUnits = 2; // اندازه ویجت بر حسب خانه

  List<Offset> widgetPositions = [
    Offset(0, 0),
    Offset(120, 0),
    Offset(0, 120),
  ];

  // موقعیت قبلی هنگام درگ
  late Offset oldPosition;

  bool isPositionFree(Offset newPos, int index) {
    for (int i = 0; i < widgetPositions.length; i++) {
      if (i == index) continue;

      final otherPos = widgetPositions[i];
      final rect1 =
      Rect.fromLTWH(newPos.dx, newPos.dy, widgetUnits * unitSize, widgetUnits * unitSize);
      final rect2 =
      Rect.fromLTWH(otherPos.dx, otherPos.dy, widgetUnits * unitSize, widgetUnits * unitSize);

      if (rect1.overlaps(rect2)) {
        return false;
      }
    }
    return true;
  }

  Offset snapToGrid(Offset pos) {
    double snappedX = (pos.dx / unitSize).round() * unitSize;
    double snappedY = (pos.dy / unitSize).round() * unitSize;
    return Offset(snappedX, snappedY);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double maxX = screenSize.width - widgetUnits * unitSize;
    double maxY = screenSize.height - widgetUnits * unitSize;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // کشیدن گرید
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(unitSize: unitSize),
          ),

          // رسم ویجت‌ها
          for (int i = 0; i < widgetPositions.length; i++)
            Positioned(
              left: widgetPositions[i].dx,
              top: widgetPositions[i].dy,
              child: GestureDetector(
                onPanStart: (_) {
                  oldPosition = widgetPositions[i];
                },
                // onPanUpdate: (details) {
                //   double newX = widgetPositions[i].dx + details.delta.dx;
                //   double newY = widgetPositions[i].dy + details.delta.dy;
                //
                //   // محدود کردن داخل صفحه
                //   newX = newX.clamp(0.0, maxX);
                //   newY = newY.clamp(0.0, maxY);
                //
                //   setState(() {
                //     widgetPositions[i] = Offset(newX, newY);
                //   });
                // },
                /*onPanEnd: (_) {
                  Offset snappedPos = snapToGrid(widgetPositions[i]);

                  // محدود کردن اسنپ به داخل صفحه
                  double clampedX = snappedPos.dx.clamp(0.0, maxX);
                  double clampedY = snappedPos.dy.clamp(0.0, maxY);
                  snappedPos = Offset(clampedX, clampedY);

                  if (isPositionFree(snappedPos, i)) {
                    setState(() {
                      widgetPositions[i] = snappedPos;
                    });
                  } else {
                    setState(() {
                      widgetPositions[i] = oldPosition;
                    });
                  }
                },*/
                onPanUpdate: (details) {
                  final screenSize = MediaQuery.of(context).size;

                  double maxX = screenSize.width - widgetUnits * unitSize;
                  double maxY = screenSize.height - widgetUnits * unitSize;

                  double newX = widgetPositions[i].dx + details.delta.dx;
                  double newY = widgetPositions[i].dy + details.delta.dy;

                  newX = newX.clamp(0.0, maxX);
                  newY = newY.clamp(0.0, maxY);

                  setState(() {
                    widgetPositions[i] = Offset(newX, newY);
                  });
                },

                onPanEnd: (_) {
                  Offset snappedPos = snapToGrid(widgetPositions[i]);

                  final screenSize = MediaQuery.of(context).size;
                  double maxX = screenSize.width - widgetUnits * unitSize;
                  double maxY = screenSize.height - widgetUnits * unitSize;

                  double clampedX = snappedPos.dx.clamp(0.0, maxX);
                  double clampedY = snappedPos.dy.clamp(0.0, maxY);
                  snappedPos = Offset(clampedX, clampedY);

                  if (isPositionFree(snappedPos, i)) {
                    setState(() {
                      widgetPositions[i] = snappedPos;
                    });
                  } else {
                    setState(() {
                      widgetPositions[i] = oldPosition;
                    });
                  }
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

          // کنترل اندازه گرید
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  "Grid Size: ${unitSize.toInt()} px",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Slider(
                  min: 40,
                  max: 120,
                  value: unitSize,
                  onChanged: (value) {
                    setState(() {
                      unitSize = value;
                      // اسنپ کردن مجدد همه ویجت‌ها به گرید جدید
                      widgetPositions = widgetPositions
                          .map((pos) => snapToGrid(pos))
                          .toList();
                    });
                  },
                ),
              ],
            ),
          )
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

