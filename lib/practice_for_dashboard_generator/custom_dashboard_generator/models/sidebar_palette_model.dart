import 'package:flutter/material.dart';

/// A palette item that can be dragged from the left sidebar.
class SidebarPaletteModel {
  final ChartType type;
  final String label;
  final IconData icon;
  final int w; // width in grid columns
  final int h; // height in grid rows
  final Color color;

  const SidebarPaletteModel({
    required this.type,
    required this.label,
    required this.icon,
    required this.w,
    required this.h,
    required this.color,
  });
}

enum ChartType {
  cartesianChart,
  circularChart,
  pyramidChart,
  funnelChart,
  sparkLineChart,
  sparkAreaChart,
  sparkBarChart,
  sparkWinLossChart;

  bool get isCartesianChart => this == ChartType.cartesianChart;

  bool get isCircularChart => this == ChartType.circularChart;

  bool get isPyramidChart => this == ChartType.pyramidChart;

  bool get isFunnelChart => this == ChartType.funnelChart;

  bool get isSparkLineChart => this == ChartType.sparkLineChart;

  bool get isSparkAreaChart => this == ChartType.sparkAreaChart;

  bool get isSparkBarChart => this == ChartType.sparkBarChart;

  bool get isSparkWinLossChart => this == ChartType.sparkWinLossChart;
}
