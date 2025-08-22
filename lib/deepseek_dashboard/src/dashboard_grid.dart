import 'package:flutter/material.dart';
import 'dashboard_controller.dart';
import 'dashboard_item.dart';
import 'grid_cell.dart';

class DashboardGrid extends StatefulWidget {
  final DashboardController controller;
  final Color gridColor;
  final bool showGrid;

  const DashboardGrid({
    Key? key,
    required this.controller,
    this.gridColor = Colors.grey,
    this.showGrid = true,
  }) : super(key: key);

  @override
  _DashboardGridState createState() => _DashboardGridState();
}

class _DashboardGridState extends State<DashboardGrid> {
  final GlobalKey _gridKey = GlobalKey();
  Offset? _lastDropPosition;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              key: _gridKey,
              color: Colors.white,
              child: Stack(
                children: [
                  if (widget.showGrid) _buildGridBackground(constraints),
                  ..._buildGridItems(),
                  // DragTarget برای کل منطقه
                  Positioned.fill(
                    child: DragTarget<DashboardItem>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(color: Colors.transparent);
                      },
                      onWillAccept: (data) => true,
                      onAccept: (data) {
                        _addItemToGrid(data, context);
                      },
                      onMove: (details) {
                        // موقعیت درگ را ذخیره می‌کنیم
                        _lastDropPosition = details.offset;
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addItemToGrid(DashboardItem data, BuildContext context) {
    if (_lastDropPosition != null && _gridKey.currentContext != null) {
      final renderBox = _gridKey.currentContext!.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(_lastDropPosition!);

      final gridX = (localPosition.dx / widget.controller.gridSize).floor();
      final gridY = (localPosition.dy / widget.controller.gridSize).floor();

      // بررسی می‌کنیم که آیا محل مورد نظر آزاد است
      if (!widget.controller.isAreaOccupied(
        gridX, gridY, data.width, data.height,
      ) && gridX >= 0 && gridY >= 0) {
        final newItem = DashboardItem(
          id: '${DateTime.now().millisecondsSinceEpoch}',
          child: data.child,
          x: gridX,
          y: gridY,
          width: data.width,
          height: data.height,
          minWidth: data.minWidth,
          maxWidth: data.maxWidth,
          minHeight: data.minHeight,
          maxHeight: data.maxHeight,
        );
        widget.controller.addItem(newItem);
      }
    }
    _lastDropPosition = null;
  }

  Widget _buildGridBackground(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: CustomPaint(
        painter: _GridPainter(
          gridSize: widget.controller.gridSize,
          gridColor: widget.gridColor,
          columns: widget.controller.columns,
          rows: (constraints.maxHeight / widget.controller.gridSize).ceil(),
        ),
      ),
    );
  }

  List<Widget> _buildGridItems() {
    return widget.controller.items.map((item) {
      return Positioned(
        left: item.x * widget.controller.gridSize.toDouble(),
        top: item.y * widget.controller.gridSize.toDouble(),
        width: item.width * widget.controller.gridSize.toDouble(),
        height: item.height * widget.controller.gridSize.toDouble(),
        child: GridCell(
          item: item,
          controller: widget.controller,
        ),
      );
    }).toList();
  }
}

class _GridPainter extends CustomPainter {
  final int gridSize;
  final Color gridColor;
  final int columns;
  final int rows;

  _GridPainter({
    required this.gridSize,
    required this.gridColor,
    required this.columns,
    required this.rows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw vertical lines
    for (int x = 0; x <= columns; x++) {
      final dx = x * gridSize.toDouble();
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    // Draw horizontal lines
    for (int y = 0; y <= rows; y++) {
      final dy = y * gridSize.toDouble();
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}