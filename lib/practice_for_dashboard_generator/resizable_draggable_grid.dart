import 'package:flutter/material.dart';

class ResizableDraggableWidget {
  Offset position; // بر حسب پیکسل
  int widthUnits;
  int heightUnits;

  ResizableDraggableWidget({
    required this.position,
    required this.widthUnits,
    required this.heightUnits,
  });
}

class ResizableDraggableGrid extends StatefulWidget {
  const ResizableDraggableGrid({super.key});

  @override
  _ResizableDraggableGridState createState() => _ResizableDraggableGridState();
}

class _ResizableDraggableGridState extends State<ResizableDraggableGrid> {
  double unitSize = 60; // اندازه هر خانه گرید (پیکسل)
  int minUnits = 1; // حداقل اندازه هر بعد ویجت بر حسب واحد

  List<ResizableDraggableWidget> widgets = [
    ResizableDraggableWidget(position: Offset(0, 0), widthUnits: 2, heightUnits: 2),
    ResizableDraggableWidget(position: Offset(120, 0), widthUnits: 2, heightUnits: 2),
    ResizableDraggableWidget(position: Offset(0, 120), widthUnits: 2, heightUnits: 2),
  ];

  late Offset oldPosition;
  late int oldWidthUnits;
  late int oldHeightUnits;

  bool isPositionFree(Offset pos, int widthUnits, int heightUnits, int index) {
    final rect1 = Rect.fromLTWH(pos.dx, pos.dy, widthUnits * unitSize, heightUnits * unitSize);

    for (int i = 0; i < widgets.length; i++) {
      if (i == index) continue;

      final w = widgets[i];
      final rect2 = Rect.fromLTWH(w.position.dx, w.position.dy, w.widthUnits * unitSize, w.heightUnits * unitSize);

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

  int snapUnits(double length) {
    return (length / unitSize).round().clamp(minUnits, 10); // حداکثر 10 واحد فرضی
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double maxX = screenSize.width;
    double maxY = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // گرید
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(unitSize: unitSize),
          ),

          // ویجت‌ها
          for (int i = 0; i < widgets.length; i++)
            Positioned(
              left: widgets[i].position.dx,
              top: widgets[i].position.dy,
              width: widgets[i].widthUnits * unitSize,
              height: widgets[i].heightUnits * unitSize,
              child: Stack(
                children: [
                  // خود ویجت با GestureDetector برای درگ کردن
                  GestureDetector(
                    onPanStart: (_) {
                      oldPosition = widgets[i].position;
                      oldWidthUnits = widgets[i].widthUnits;
                      oldHeightUnits = widgets[i].heightUnits;
                    },
                    onPanUpdate: (details) {
                      double newX = widgets[i].position.dx + details.delta.dx;
                      double newY = widgets[i].position.dy + details.delta.dy;

                      // محدود کردن داخل صفحه (موقعیت ویجت)
                      newX = newX.clamp(0.0, maxX - widgets[i].widthUnits * unitSize);
                      newY = newY.clamp(0.0, maxY - widgets[i].heightUnits * unitSize);

                      setState(() {
                        widgets[i].position = Offset(newX, newY);
                      });
                    },
                    onPanEnd: (_) {
                      Offset snappedPos = snapToGrid(widgets[i].position);

                      // محدود کردن اسنپ به داخل صفحه
                      double clampedX = snappedPos.dx.clamp(0.0, maxX - widgets[i].widthUnits * unitSize);
                      double clampedY = snappedPos.dy.clamp(0.0, maxY - widgets[i].heightUnits * unitSize);
                      snappedPos = Offset(clampedX, clampedY);

                      if (isPositionFree(snappedPos, widgets[i].widthUnits, widgets[i].heightUnits, i)) {
                        setState(() {
                          widgets[i].position = snappedPos;
                        });
                      } else {
                        setState(() {
                          widgets[i].position = oldPosition;
                          widgets[i].widthUnits = oldWidthUnits;
                          widgets[i].heightUnits = oldHeightUnits;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Widget $i",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  // دستگیره‌ها (4 طرف)
                  // بالا وسط
                  buildHandle(i, Alignment.topCenter, (dx, dy) {
                    // تغییر ارتفاع از بالا
                    int newHeightUnits = (widgets[i].heightUnits - snapUnits(dy)).clamp(minUnits, 10);
                    double heightDiff = (widgets[i].heightUnits - newHeightUnits) * unitSize;
                    Offset newPos = widgets[i].position + Offset(0, heightDiff);

                    // محدود کردن موقعیت و اندازه
                    if (newPos.dy < 0) return;
                    if (newPos.dy + newHeightUnits * unitSize > maxY) return;

                    if (isPositionFree(newPos, widgets[i].widthUnits, newHeightUnits, i)) {
                      setState(() {
                        widgets[i].heightUnits = newHeightUnits;
                        widgets[i].position = newPos;
                      });
                    }
                  }),

                  // پایین وسط
                  buildHandle(i, Alignment.bottomCenter, (dx, dy) {
                    // تغییر ارتفاع از پایین
                    int newHeightUnits = (widgets[i].heightUnits + snapUnits(dy)).clamp(minUnits, 10);

                    if (widgets[i].position.dy + newHeightUnits * unitSize > maxY) return;

                    if (isPositionFree(widgets[i].position, widgets[i].widthUnits, newHeightUnits, i)) {
                      setState(() {
                        widgets[i].heightUnits = newHeightUnits;
                      });
                    }
                  }),

                  // وسط چپ
                  buildHandle(i, Alignment.centerLeft, (dx, dy) {
                    // تغییر عرض از چپ
                    int newWidthUnits = (widgets[i].widthUnits - snapUnits(dx)).clamp(minUnits, 10);
                    double widthDiff = (widgets[i].widthUnits - newWidthUnits) * unitSize;
                    Offset newPos = widgets[i].position + Offset(widthDiff, 0);

                    if (newPos.dx < 0) return;
                    if (newPos.dx + newWidthUnits * unitSize > maxX) return;

                    if (isPositionFree(newPos, newWidthUnits, widgets[i].heightUnits, i)) {
                      setState(() {
                        widgets[i].widthUnits = newWidthUnits;
                        widgets[i].position = newPos;
                      });
                    }
                  }),

                  // وسط راست
                  buildHandle(i, Alignment.centerRight, (dx, dy) {
                    // تغییر عرض از راست
                    int newWidthUnits = (widgets[i].widthUnits + snapUnits(dx)).clamp(minUnits, 10);

                    if (widgets[i].position.dx + newWidthUnits * unitSize > maxX) return;

                    if (isPositionFree(widgets[i].position, newWidthUnits, widgets[i].heightUnits, i)) {
                      setState(() {
                        widgets[i].widthUnits = newWidthUnits;
                      });
                    }
                  }),
                ],
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
                      // اسنپ کردن مجدد موقعیت‌ها به گرید جدید
                      for (var w in widgets) {
                        w.position = snapToGrid(w.position);
                        // همچنین اندازه‌ها رو میشه اینجا به دلخواه اسنپ کرد (اختیاری)
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHandle(int widgetIndex, Alignment alignment, Function(double dx, double dy) onDrag) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          onDrag(details.delta.dx, details.delta.dy);
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            shape: BoxShape.rectangle,
          ),
        ),
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
