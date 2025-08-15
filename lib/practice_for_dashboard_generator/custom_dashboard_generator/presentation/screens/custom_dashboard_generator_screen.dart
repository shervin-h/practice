import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/dashboard_widget_model.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/sidebar_palette_model.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/controllers/custom_dashboard_generator_controller.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/widgets/draggable_resizable_widget.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/widgets/open_sidebar_button.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/widgets/sidebar/sidebar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../dynamic_snap_grid_example.dart';

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class CustomDashboardGeneratorScreen extends StatefulWidget {
  const CustomDashboardGeneratorScreen({super.key});

  @override
  State<CustomDashboardGeneratorScreen> createState() => _CustomDashboardGeneratorScreenState();
}

class _CustomDashboardGeneratorScreenState extends State<CustomDashboardGeneratorScreen> {
  double unitSize = 90; // اندازه هر خانه گرید (پیکسل)
  double widgetUnits = 2; // اندازه ویجت بر حسب خانه

  List<Offset> widgetPositions = [
    Offset(0, 0),
    Offset(180, 0),
    Offset(0, 180),
  ];

  // موقعیت قبلی هنگام درگ
  late Offset oldPosition;

  bool isPositionFree(Offset newPos, int index) {
    for (int i = 0; i < widgetPositions.length; i++) {
      if (i == index) continue;

      final otherPos = widgetPositions[i];
      final rect1 = Rect.fromLTWH(newPos.dx, newPos.dy, widgetUnits * unitSize, widgetUnits * unitSize);
      final rect2 = Rect.fromLTWH(otherPos.dx, otherPos.dy, widgetUnits * unitSize, widgetUnits * unitSize);

      if (rect1.overlaps(rect2)) {
        return false;
      }
    }
    return true;
  }

  Offset snapToGrid(Offset pos) {
    double snappedX = (pos.dx / unitSize).round() * unitSize;
    double snappedY = (pos.dy / unitSize).round() * unitSize;
    return Offset(snappedX, snappedY);
  }

  final List<Color> _colors = [Colors.blue, Colors.red, Colors.orange];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // draw grid
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(unitSize: unitSize),
          ),

          /*for (int i = 0; i < widgetPositions.length; i++)
            Positioned(
              left: widgetPositions[i].dx,
              top: widgetPositions[i].dy,
              child: GestureDetector(
                onPanStart: (_) {
                  oldPosition = widgetPositions[i];
                },
                onPanUpdate: (details) {
                  final screenSize = MediaQuery.of(context).size;

                  double maxX = screenSize.width - widgetUnits * unitSize;
                  double maxY = screenSize.height - widgetUnits * unitSize;

                  double newX = widgetPositions[i].dx + details.delta.dx;
                  double newY = widgetPositions[i].dy + details.delta.dy;

                  newX = newX.clamp(0.0, maxX);
                  newY = newY.clamp(0.0, maxY);

                  setState(() {
                    widgetPositions[i] = Offset(newX, newY);
                  });
                },
                onPanEnd: (_) {
                  Offset snappedPos = snapToGrid(widgetPositions[i]);

                  final screenSize = MediaQuery.of(context).size;
                  double maxX = screenSize.width - widgetUnits * unitSize;
                  double maxY = screenSize.height - widgetUnits * unitSize;

                  double clampedX = snappedPos.dx.clamp(0.0, maxX);
                  double clampedY = snappedPos.dy.clamp(0.0, maxY);
                  snappedPos = Offset(clampedX, clampedY);

                  if (isPositionFree(snappedPos, i)) {
                    setState(() {
                      widgetPositions[i] = snappedPos;
                    });
                  } else {
                    setState(() {
                      widgetPositions[i] = oldPosition;
                    });
                  }
                },
                child: Container(
                  width: widgetUnits * unitSize,
                  height: widgetUnits * unitSize,
                  decoration: BoxDecoration(
                    color: _colors[i],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Widget $i",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),*/

          GetBuilder<CustomDashboardGeneratorController>(
              id: 'custom-dashboard',
              builder: (controller) {
                return Positioned.fill(
                  child: DragTarget<SidebarPaletteModel>(
                    onWillAcceptWithDetails: (dragTargetDetails) => true,
                    onAcceptWithDetails: (dragTargetDetails) {
                      final sidebarPaletteModel = dragTargetDetails.data;
                      controller.addDashboardWidget(DashboardWidgetModel.fromSidebarPaletteModel(sidebarPaletteModel));

                      /*if (sidebarPaletteModel.type.isCartesianChart) {}
                      if (sidebarPaletteModel.type.isCircularChart) {
                        controller.addWidget(Container(
                          width: 300,
                          height: 300,
                          child: const SfCircularChart(),
                        ));
                      }
                      if (sidebarPaletteModel.type.isPyramidChart) {
                        controller.addWidget(const SizedBox(
                          width: 400,
                          height: 400,
                          child: const SfPyramidChart(),
                        ));
                      }
                      if (sidebarPaletteModel.type.isFunnelChart) {
                        controller.addWidget(const SfFunnelChart());
                      }
                      if (sidebarPaletteModel.type.isSparkLineChart) {
                        controller.addWidget(SizedBox(
                          width: 300,
                          height: 300,
                          child: SfSparkLineChart(
                            data: const <double>[1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 13, -6, 7, 5, 11, 5, 3],
                          ),
                        ));
                      }
                      if (sidebarPaletteModel.type.isSparkAreaChart) {
                        controller.addWidget(SfSparkLineChart());
                      }
                      if (sidebarPaletteModel.type.isSparkBarChart) {
                        controller.addWidget(SfSparkBarChart());
                      }
                      if (sidebarPaletteModel.type.isSparkWinLossChart) {
                        controller.addWidget(SfSparkWinLossChart());
                      }*/
                    },
                    builder: (context, paletteModels, rejectedData) {
                      return Stack(
                        children: controller.dashboardWidgetModels
                            .map(
                              (element) => DraggableResizableWidget(
                                dashboardWidgetModel: element,
                                child: SfCartesianChart(
                                  // Initialize category axis
                                  primaryXAxis: const CategoryAxis(),
                                  series: <LineSeries<SalesData, String>>[
                                    LineSeries<SalesData, String>(
                                      // Bind data source
                                      dataSource: <SalesData>[
                                        SalesData('Jan', 35),
                                        SalesData('Feb', 28),
                                        SalesData('Mar', 34),
                                        SalesData('Apr', 32),
                                        SalesData('May', 40)
                                      ],
                                      xValueMapper: (SalesData sales, _) => sales.year,
                                      yValueMapper: (SalesData sales, _) => sales.sales,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                );
              }),

          const OpenSidebarButton(),

          GetBuilder<CustomDashboardGeneratorController>(
            id: 'sidebar',
            builder: (controller) {
              final isOpen = controller.isSidebarOpen;
              return AnimatedPositionedDirectional(
                duration: const Duration(milliseconds: 300),
                width: 250,
                start: isOpen ? 0 : -250,
                top: 0,
                bottom: 0,
                child: const Sidebar(),
              );
            },
          ),
        ],
      ),
    );
  }
}
