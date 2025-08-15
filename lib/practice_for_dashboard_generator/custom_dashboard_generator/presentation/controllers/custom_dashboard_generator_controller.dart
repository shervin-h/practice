import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/sidebar_palette_model.dart';

class CustomDashboardGeneratorController extends GetxController {
  // states
  bool _isSidebarOpen = false;
  final double _unitSize = 90;
  final List<Widget> _dashboardWidgets = []; // Placed items on the grid
  final List<SidebarPaletteModel> _sidebarItems = const [
    SidebarPaletteModel(type: ChartType.cartesianChart, label: 'Cartesian Chart', icon: Icons.show_chart, w: 4, h: 3, color: Color(0xFF4F46E5)),
    SidebarPaletteModel(type: ChartType.circularChart, label: 'Circular Chart', icon: Icons.bar_chart, w: 4, h: 4, color: Color(0xFF06B6D4)),
    SidebarPaletteModel(type: ChartType.pyramidChart, label: 'Pyramid Chart', icon: Icons.speed, w: 3, h: 2, color: Color(0xFFF59E0B)),
    SidebarPaletteModel(type: ChartType.funnelChart, label: 'Funnel Chart', icon: Icons.table_chart, w: 6, h: 4, color: Color(0xFF10B981)),
    SidebarPaletteModel(type: ChartType.sparkLineChart, label: 'SparkLine Chart', icon: Icons.text_fields, w: 4, h: 2, color: Color(0xFFE11D48)),
  ]; // Demo palette

  // getters
  bool get isSidebarOpen => _isSidebarOpen;

  double get unitSize => _unitSize;

  List<Widget> get dashboardWidgets => _dashboardWidgets;

  List<SidebarPaletteModel> get sidebarItems => _sidebarItems;

  // actions
  void openSidebar() {
    _isSidebarOpen = true;
    update(['sidebar']);
  }

  void closeSidebar() {
    _isSidebarOpen = false;
    update(['sidebar']);
  }

  void addWidget(Widget widget) {
    if (!_dashboardWidgets.contains(widget)) {
      _dashboardWidgets.add(widget);
      update(['custom-dashboard']);
    }
  }

  void removeWidget(Widget widget) {
    if (_dashboardWidgets.contains(widget)) {
      _dashboardWidgets.remove(widget);
      update(['custom-dashboard']);
    }
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
      update(['sidebar-pallets']);
    }
  }
}
