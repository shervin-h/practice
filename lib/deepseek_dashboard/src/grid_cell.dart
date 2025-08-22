import 'package:flutter/material.dart';
import 'dashboard_controller.dart';
import 'dashboard_item.dart';
import 'resize_handle.dart';

class GridCell extends StatefulWidget {
  final DashboardItem item;
  final DashboardController controller;

  const GridCell({
    Key? key,
    required this.item,
    required this.controller,
  }) : super(key: key);

  @override
  _GridCellState createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  bool _isDragging = false;
  Offset _startOffset = Offset.zero;
  int _startX = 0;
  int _startY = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content with drag handle
        Positioned.fill(
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Listener(
              onPointerDown: _onPanStart,
              onPointerMove: _onPanUpdate,
              onPointerUp: _onPanEnd,
              onPointerCancel: (e) {},
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: Center(child: widget.item.child),
              ),
            ),
          ),
        ),

        // Resize handles - با z-index بالاتر
        Positioned(
          top: 0,
          left: 0,
          child: ResizeHandle(
              item: widget.item,
              controller: widget.controller,
              handleType: ResizeHandleType.topLeft
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: ResizeHandle(
              item: widget.item,
              controller: widget.controller,
              handleType: ResizeHandleType.topRight
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: ResizeHandle(
              item: widget.item,
              controller: widget.controller,
              handleType: ResizeHandleType.bottomLeft
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ResizeHandle(
              item: widget.item,
              controller: widget.controller,
              handleType: ResizeHandleType.bottomRight
          ),
        ),
      ],
    );
  }

  void _onPanStart(PointerDownEvent event) {
    _isDragging = true;
    _startOffset = event.position;
    _startX = widget.item.x;
    _startY = widget.item.y;
  }

  void _onPanUpdate(PointerMoveEvent event) {
    if (!_isDragging) return;

    final delta = event.position - _startOffset;
    final gridDeltaX = (delta.dx / widget.controller.gridSize).round();
    final gridDeltaY = (delta.dy / widget.controller.gridSize).round();

    if (gridDeltaX != 0 || gridDeltaY != 0) {
      final newX = _startX + gridDeltaX;
      final newY = _startY + gridDeltaY;

      if (newX >= 0 && newY >= 0 &&
          newX + widget.item.width <= widget.controller.columns &&
          !widget.controller.isAreaOccupied(newX, newY, widget.item.width, widget.item.height, excludeItemId: widget.item.id)) {
        widget.controller.updateItemPosition(widget.item.id, newX, newY);
      }
    }
  }

  void _onPanEnd(PointerUpEvent event) {
    _isDragging = false;
  }
}