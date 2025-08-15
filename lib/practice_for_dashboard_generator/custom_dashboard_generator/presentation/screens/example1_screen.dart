import 'package:flutter/material.dart';

import '../../../dynamic_snap_grid_example.dart';



class Example1Screen extends StatefulWidget {
  const Example1Screen({super.key});

  @override
  State<Example1Screen> createState() => _Example1ScreenState();
}

class _Example1ScreenState extends State<Example1Screen> {
  double unitSize = 90; // اندازه هر خانه گرید (پیکسل)
  double widgetUnits = 2; // اندازه ویجت بر حسب خانه

  List<Offset> widgetPositions = [
    Offset(0, 0),
    Offset(180, 0),
    Offset(0, 180),
  ];

  // موقعیت قبلی هنگام درگ
  late Offset oldPosition;

  bool isPositionFree(Offset newPos, int index) {
    for (int i = 0; i < widgetPositions.length; i++) {
      if (i == index) continue;

      final otherPos = widgetPositions[i];
      final rect1 = Rect.fromLTWH(newPos.dx, newPos.dy, widgetUnits * unitSize, widgetUnits * unitSize);
      final rect2 = Rect.fromLTWH(otherPos.dx, otherPos.dy, widgetUnits * unitSize, widgetUnits * unitSize);

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

  final List<Color> _colors = [Colors.blue, Colors.red, Colors.orange];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double maxX = screenSize.width - widgetUnits * unitSize;
    double maxY = screenSize.height - widgetUnits * unitSize;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // draw grid
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(unitSize: unitSize),
          ),

          for (int i = 0; i < widgetPositions.length; i++)
            Positioned(
              left: widgetPositions[i].dx,
              top: widgetPositions[i].dy,
              child: GestureDetector(
                onPanStart: (_) {
                  oldPosition = widgetPositions[i];
                },
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
                    color: _colors[i],
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
