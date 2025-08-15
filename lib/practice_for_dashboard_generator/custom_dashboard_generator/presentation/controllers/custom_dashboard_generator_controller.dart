import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/dashboard_widget_model.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/sidebar_palette_model.dart';

class CustomDashboardGeneratorController extends GetxController {
  /// --- states --- ///
  bool _isSidebarOpen = false;
  final double _unitSize = 90;
  final List<DashboardWidgetModel> _dashboardWidgetModels = [
    DashboardWidgetModel(
      id: 'widget-1',
      offset: const Offset(0, 0),
      w: 3,
      h: 2,
      label: 'Widget 1',
      color: Colors.green,
    ),
    DashboardWidgetModel(
      id: 'widget-2',
      offset: const Offset(0, 270),
      w: 3,
      h: 1,
      label: 'Widget 2',
      color: Colors.red,
    ),
  ];
  final List<SidebarPaletteModel> _sidebarItems = const [
    SidebarPaletteModel(
      type: ChartType.cartesianChart,
      label: 'Cartesian Chart',
      icon: Icons.show_chart,
      w: 4,
      h: 3,
      color: Color(0xFF4F46E5),
    ),
    SidebarPaletteModel(
      type: ChartType.circularChart,
      label: 'Circular Chart',
      icon: Icons.bar_chart,
      w: 4,
      h: 4,
      color: Color(0xFF06B6D4),
    ),
    SidebarPaletteModel(
      type: ChartType.pyramidChart,
      label: 'Pyramid Chart',
      icon: Icons.speed,
      w: 3,
      h: 2,
      color: Color(0xFFF59E0B),
    ),
    SidebarPaletteModel(
      type: ChartType.funnelChart,
      label: 'Funnel Chart',
      icon: Icons.table_chart,
      w: 6,
      h: 4,
      color: Color(0xFF10B981),
    ),
    SidebarPaletteModel(
      type: ChartType.sparkLineChart,
      label: 'SparkLine Chart',
      icon: Icons.text_fields,
      w: 4,
      h: 2,
      color: Color(0xFFE11D48),
    ),
  ]; // Demo palette

  late Offset oldPosition;

  /// --- getters --- ///
  bool get isSidebarOpen => _isSidebarOpen;

  double get unitSize => _unitSize;

  List<DashboardWidgetModel> get dashboardWidgetModels => _dashboardWidgetModels;

  List<SidebarPaletteModel> get sidebarItems => _sidebarItems;

  /// --- actions --- ///
  /// sidebar
  void openSidebar() {
    _isSidebarOpen = true;
    update(['sidebar']);
  }

  void closeSidebar() {
    _isSidebarOpen = false;
    update(['sidebar']);
  }

  void addSidebarItem(SidebarPaletteModel item) {
    if (!_sidebarItems.contains(item)) {
      _sidebarItems.add(item);
      update(['sidebar-pallets']);
    }
  }

  void removeSidebarItem(SidebarPaletteModel item) {
    if (_sidebarItems.contains(item)) {
      _sidebarItems.remove(item);
      update(['sidebar-palettes']);
    }
  }

  /// dashboard widgets
  void updateWidgetOffset(String id, Offset newOffset) {
    for (final model in _dashboardWidgetModels) {
      if (model.id == id) {
        model.updateOffset(newOffset);
        update(['custom-dashboard']);
      }
    }
  }

  DashboardWidgetModel? getSpecificWidgetModel(String id) {
    for (final model in _dashboardWidgetModels) {
      if (model.id == id) {
        return model;
      }
    }
    return null;
  }

  void addDashboardWidget(DashboardWidgetModel widgetModel) {
    if (!_dashboardWidgetModels.contains(widgetModel)) {
      _dashboardWidgetModels.add(widgetModel);
      update(['custom-dashboard']);
    }
  }

  void removeDashboardWidget(DashboardWidgetModel widgetModel) {
    if (_dashboardWidgetModels.contains(widgetModel)) {
      _dashboardWidgetModels.remove(widgetModel);
      update(['custom-dashboard']);
    }
  }
}
