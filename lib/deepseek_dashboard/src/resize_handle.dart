import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_controller.dart';
import 'dashboard_item.dart';

enum ResizeHandleType {
  topLeft, topRight, bottomLeft, bottomRight,
  top, bottom, left, right
}

class ResizeHandle extends StatefulWidget {
  final DashboardItem item;
  final DashboardController controller;
  final ResizeHandleType handleType;

  const ResizeHandle({
    Key? key,
    required this.item,
    required this.controller,
    required this.handleType,
  }) : super(key: key);

  @override
  _ResizeHandleState createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  Offset _startOffset = Offset.zero;
  int _startX = 0;
  int _startY = 0;
  int _startWidth = 0;
  int _startHeight = 0;
  bool _isResizing = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _getCursorForHandleType(widget.handleType),
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: (e) {},
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: _isResizing ? Colors.blueAccent : Colors.blue,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }

  SystemMouseCursor _getCursorForHandleType(ResizeHandleType type) {
    switch (type) {
      case ResizeHandleType.topLeft:
        return SystemMouseCursors.resizeUpLeft;
      case ResizeHandleType.topRight:
        return SystemMouseCursors.resizeUpRight;
      case ResizeHandleType.bottomLeft:
        return SystemMouseCursors.resizeDownLeft;
      case ResizeHandleType.bottomRight:
        return SystemMouseCursors.resizeDownRight;
      case ResizeHandleType.top:
      case ResizeHandleType.bottom:
        return SystemMouseCursors.resizeUpDown;
      case ResizeHandleType.left:
      case ResizeHandleType.right:
        return SystemMouseCursors.resizeLeftRight;
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    _startOffset = event.position;
    _startX = widget.item.x;
    _startY = widget.item.y;
    _startWidth = widget.item.width;
    _startHeight = widget.item.height;
    _isResizing = true;

    // رویداد را بگیر و به والدین نده
    // event.stopPropagation();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isResizing) return;

    final delta = event.position - _startOffset;
    final gridDeltaX = (delta.dx / widget.controller.gridSize).round();
    final gridDeltaY = (delta.dy / widget.controller.gridSize).round();

    if (gridDeltaX == 0 && gridDeltaY == 0) return;

    int newWidth = _startWidth;
    int newHeight = _startHeight;
    int newX = _startX;
    int newY = _startY;

    switch (widget.handleType) {
      case ResizeHandleType.bottomRight:
        newWidth = _clampSize(_startWidth + gridDeltaX, widget.item.minWidth, widget.item.maxWidth);
        newHeight = _clampSize(_startHeight + gridDeltaY, widget.item.minHeight, widget.item.maxHeight);
        break;
      case ResizeHandleType.bottomLeft:
        newWidth = _clampSize(_startWidth - gridDeltaX, widget.item.minWidth, widget.item.maxWidth);
        newHeight = _clampSize(_startHeight + gridDeltaY, widget.item.minHeight, widget.item.maxHeight);
        newX = _startX + gridDeltaX;
        break;
      case ResizeHandleType.topRight:
        newWidth = _clampSize(_startWidth + gridDeltaX, widget.item.minWidth, widget.item.maxWidth);
        newHeight = _clampSize(_startHeight - gridDeltaY, widget.item.minHeight, widget.item.maxHeight);
        newY = _startY + gridDeltaY;
        break;
      case ResizeHandleType.topLeft:
        newWidth = _clampSize(_startWidth - gridDeltaX, widget.item.minWidth, widget.item.maxWidth);
        newHeight = _clampSize(_startHeight - gridDeltaY, widget.item.minHeight, widget.item.maxHeight);
        newX = _startX + gridDeltaX;
        newY = _startY + gridDeltaY;
        break;
      default:
        return;
    }

    // بررسی مرزها و برخورد
    if (newX >= 0 && newY >= 0 &&
        newX + newWidth <= widget.controller.columns &&
        newWidth >= widget.item.minWidth &&
        newHeight >= widget.item.minHeight &&
        newWidth <= widget.item.maxWidth &&
        newHeight <= widget.item.maxHeight &&
        !widget.controller.isAreaOccupied(newX, newY, newWidth, newHeight, excludeItemId: widget.item.id)) {

      widget.controller.updateItemSize(widget.item.id, newWidth, newHeight, newX, newY);
    }

    // event.stopPropagation();
  }

  void _onPointerUp(PointerUpEvent event) {
    _isResizing = false;
    // event.stopPropagation();
  }

  int _clampSize(int size, int min, int max) {
    return size.clamp(min, max);
  }
}