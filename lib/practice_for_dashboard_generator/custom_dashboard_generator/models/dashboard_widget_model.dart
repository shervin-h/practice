import 'dart:ui';

import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/sidebar_palette_model.dart';

class DashboardWidgetModel {
  final String id;
  Offset offset;
  final int w; // width in columns // اندازه عرض ویجت بر حسب خانه
  final int h; // height in rows // اندازه ارتفاع ویجت بر حسب خانه
  final String label;
  final Color color;

  DashboardWidgetModel({
    required this.id,
    required this.offset,
    required this.w,
    required this.h,
    required this.label,
    required this.color,
  });

  void updateOffset(Offset newOffset) {
    offset = newOffset;
  }

  static DashboardWidgetModel fromSidebarPaletteModel(SidebarPaletteModel sidebarModel) {
    return DashboardWidgetModel(
      id: sidebarModel.type.title,
      offset: const Offset(0, 0),
      w: sidebarModel.w,
      h: sidebarModel.h,
      label: sidebarModel.label,
      color: sidebarModel.color,
    );
  }
}
