import 'package:flutter/material.dart';

class PlayForMakeDashboardScreen extends StatefulWidget {
  const PlayForMakeDashboardScreen({super.key});

  @override
  State<PlayForMakeDashboardScreen> createState() => _PlayForMakeDashboardScreenState();
}

class _PlayForMakeDashboardScreenState extends State<PlayForMakeDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ResizableWidget(
              initialWidth: 100,
              initialHeight: 100,
              offset: Offset(200, 200),
            ),
            ResizableWidget(
              initialWidth: 100,
              initialHeight: 100,
              offset: Offset(400, 400),
            ),
          ],
        ),
      ),
    );
  }
}

class ResizableWidget extends StatefulWidget {
  const ResizableWidget({
    required this.initialWidth,
    required this.initialHeight,
    required this.offset,
    super.key,
  });

  final double initialWidth;
  final double initialHeight;
  final Offset offset;

  @override
  State<ResizableWidget> createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  final double unitSize = 96;
  late double _width;
  late double _height;

  double _start = 0;
  double _top = 0;

  Offset? _startDrag;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;
    _start = widget.offset.dx;
    _top = widget.offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: _start,
      top: _top,
      child: SizedBox(
        width: _width,
        height: _height,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Resizable Widget', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),

            // drag to right
            PositionedDirectional(
              end: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (dragStartDetails) {
                  _startDrag = dragStartDetails.globalPosition;
                },
                onPanUpdate: (dragUpdateDetails) {
                  if (_startDrag != null) {
                    final delta = dragUpdateDetails.globalPosition.dx - _startDrag!.dx;
                    if (delta.abs() >= 10) {
                      _width += 10 * delta.sign;
                      _startDrag = dragUpdateDetails.globalPosition;
                      setState(() {});
                    }
                  }
                },
                onPanEnd: (dragEndDetails) {
                  final units = (_width / unitSize).ceil();
                  if (units > 1) {
                    _width = unitSize * units;
                  } else {
                    _width = widget.initialWidth;
                  }
                  setState(() {});
                },
                child: SizedBox(
                  width: 10,
                  height: _height,
                  child: Center(
                    child: Container(
                      width: 2,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // drag to bottom
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (dragStartDetails) {
                  _startDrag = dragStartDetails.globalPosition;
                },
                onPanUpdate: (dragUpdateDetails) {
                  if (_startDrag != null) {
                    final delta = dragUpdateDetails.globalPosition.dy - _startDrag!.dy;
                    if (delta.abs() >= 10) {
                      _height += 10 * delta.sign;
                      _startDrag = dragUpdateDetails.globalPosition;
                      setState(() {});
                    }
                  }
                },
                onPanEnd: (dragEndDetails) {
                  final units = (_height / unitSize).ceil();
                  if (units > 1) {
                    _height = unitSize * units;
                  } else {
                    _height = widget.initialHeight;
                  }
                  setState(() {});
                },
                child: SizedBox(
                  width: _width,
                  height: 10,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // drag to left
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (dragStartDetails) {
                  _startDrag = dragStartDetails.globalPosition;
                },
                onPanUpdate: (dragUpdateDetails) {
                  if (_startDrag != null) {
                    final delta = _startDrag!.dx - dragUpdateDetails.globalPosition.dy;
                    if (delta.abs() >= 10) {
                      _width += 10 /** delta.sign*/;
                      _start -= 10;
                      _startDrag = dragUpdateDetails.globalPosition;
                      setState(() {});
                    }
                  }
                },
                onPanEnd: (dragEndDetails) {
                  final units = (_width / unitSize).ceil();
                  if (units > 1) {
                    _width = unitSize * units;
                  } else {
                    _width = widget.initialWidth;
                    _start += 10;
                  }
                  setState(() {});
                },
                child: SizedBox(
                  width: 10,
                  height: _height,
                  child: Center(
                    child: Container(
                      width: 2,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle({required bool isHorizontal, required bool isPositive}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        _startDrag = details.globalPosition;
      },
      onPanUpdate: (details) {
        if (_startDrag != null) {
          double delta =
              isHorizontal ? details.globalPosition.dx - _startDrag!.dx : details.globalPosition.dy - _startDrag!.dy;

          if (!isPositive) delta = -delta; // معکوس برای چپ و بالا

          if (delta.abs() >= 10) {
            setState(() {
              if (isHorizontal) {
                _width += 10 * delta.sign;
              } else {
                _height += 10 * delta.sign;
              }
            });
            _startDrag = details.globalPosition;
          }
        }
      },
      onPanEnd: (details) {
        if (isHorizontal) {
          final int widthUnits = (_width / unitSize).round();
          setState(() {
            _width = widthUnits > 0 ? widthUnits * unitSize : widget.initialWidth;
          });
        } else {
          final int heightUnits = (_height / unitSize).round();
          setState(() {
            _height = heightUnits > 0 ? heightUnits * unitSize : widget.initialHeight;
          });
        }
      },
      child: SizedBox(
        width: isHorizontal ? 10 : _width,
        height: isHorizontal ? _height : 10,
        child: Center(
          child: Container(
            width: isHorizontal ? 2 : _width,
            height: isHorizontal ? 20 : 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
