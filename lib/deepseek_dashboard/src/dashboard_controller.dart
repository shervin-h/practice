// dashboard_controller.dart
import 'package:flutter/foundation.dart';
import 'dashboard_item.dart';

class DashboardController with ChangeNotifier {
  final List<DashboardItem> _items = [];
  final int gridSize;
  final int columns;

  DashboardController({this.gridSize = 50, this.columns = 12});

  List<DashboardItem> get items => List.unmodifiable(_items);

  void addItem(DashboardItem item) {
    if (!isAreaOccupied(item.x, item.y, item.width, item.height)) {
      _items.add(item);
      notifyListeners();
      print('Item added at position: (${item.x}, ${item.y})');
    } else {
      print('Position occupied: (${item.x}, ${item.y})');
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateItemPosition(String itemId, int newX, int newY) {
    try {
      final item = _items.firstWhere((item) => item.id == itemId);
      if (!isAreaOccupied(newX, newY, item.width, item.height, excludeItemId: itemId)) {
        item.x = newX;
        item.y = newY;
        notifyListeners();
        print('Item $itemId moved to: ($newX, $newY)');
      }
    } catch (e) {
      print('Error moving item: $e');
    }
  }

  void updateItemSize(String itemId, int newWidth, int newHeight, int newX, int newY) {
    try {
      final item = _items.firstWhere((item) => item.id == itemId);
      if (!isAreaOccupied(newX, newY, newWidth, newHeight, excludeItemId: itemId)) {
        item.x = newX;
        item.y = newY;
        item.width = newWidth;
        item.height = newHeight;
        notifyListeners();
        print('Item $itemId resized to: ${newWidth}x$newHeight at ($newX, $newY)');
      }
    } catch (e) {
      print('Error resizing item: $e');
    }
  }

  bool isAreaOccupied(int x, int y, int width, int height, {String? excludeItemId}) {
    for (var item in _items) {
      if (excludeItemId != null && item.id == excludeItemId) continue;

      if (x < item.x + item.width &&
          x + width > item.x &&
          y < item.y + item.height &&
          y + height > item.y) {
        return true;
      }
    }
    return false;
  }

  DashboardItem? getItemAtPosition(int x, int y) {
    for (var item in _items) {
      if (x >= item.x && x < item.x + item.width &&
          y >= item.y && y < item.y + item.height) {
        return item;
      }
    }
    return null;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}