import 'package:flutter/widgets.dart';

class DashboardItem {
  final String id;
  final Widget child;
  int x;
  int y;
  int width;
  int height;
  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;

  DashboardItem({
    required this.id,
    required this.child,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.minWidth = 1,
    this.maxWidth = 12,
    this.minHeight = 1,
    this.maxHeight = 12,
  });

  DashboardItem.copy(DashboardItem other)
      : id = other.id,
        child = other.child,
        x = other.x,
        y = other.y,
        width = other.width,
        height = other.height,
        minWidth = other.minWidth,
        maxWidth = other.maxWidth,
        minHeight = other.minHeight,
        maxHeight = other.maxHeight;

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'width': width,
    'height': height,
    'minWidth': minWidth,
    'maxWidth': maxWidth,
    'minHeight': minHeight,
    'maxHeight': maxHeight,
  };

  factory DashboardItem.fromJson(Map<String, dynamic> json, Widget child) {
    return DashboardItem(
      id: json['id'],
      child: child,
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
      minWidth: json['minWidth'] ?? 1,
      maxWidth: json['maxWidth'] ?? 12,
      minHeight: json['minHeight'] ?? 1,
      maxHeight: json['maxHeight'] ?? 12,
    );
  }
}