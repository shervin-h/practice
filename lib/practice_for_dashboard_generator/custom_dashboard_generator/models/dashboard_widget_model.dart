import 'dart:ui';

class DashboardWidget {
  final String id;
  int x; // column index (0-based)
  int y; // row index (0-based)
  int w; // width in columns
  int h; // height in rows
  final String label;
  final Color color;

  DashboardWidget({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.label,
    required this.color,
  });
}