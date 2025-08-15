import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/dashboard_widget_model.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/controllers/custom_dashboard_generator_controller.dart';

class DraggableResizableWidget extends StatelessWidget {
  const DraggableResizableWidget({required this.dashboardWidgetModel, required this.child, super.key});

  final DashboardWidgetModel dashboardWidgetModel;
  final Widget child;

  Offset _snapToGrid(Offset pos, double unitSize) {
    double snappedX = (pos.dx / unitSize).round() * unitSize;
    double snappedY = (pos.dy / unitSize).round() * unitSize;
    return Offset(snappedX, snappedY);
  }

  bool _isPositionFree(Offset newPos, String id, List<DashboardWidgetModel> widgetModels, double unitSize) {
    for (int i = 0; i < widgetModels.length; i++) {
      if (widgetModels[i].id == id) continue;

      final otherPos = widgetModels[i].offset;
      final rect1 =
          Rect.fromLTWH(newPos.dx, newPos.dy, dashboardWidgetModel.w * unitSize, dashboardWidgetModel.h * unitSize);
      final rect2 =
          Rect.fromLTWH(otherPos.dx, otherPos.dy, widgetModels[i].w * unitSize, widgetModels[i].h * unitSize);

      if (rect1.overlaps(rect2)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomDashboardGeneratorController>();

    return PositionedDirectional(
      start: dashboardWidgetModel.offset.dx,
      top: dashboardWidgetModel.offset.dy,
      child: GestureDetector(
        onPanStart: (_) {
          controller.oldPosition = dashboardWidgetModel.offset;
        },
        onPanUpdate: (details) {
          final screenSize = MediaQuery.of(context).size;

          double maxX = screenSize.width - dashboardWidgetModel.w * controller.unitSize;
          double maxY = screenSize.height - dashboardWidgetModel.h * controller.unitSize;

          double newX = dashboardWidgetModel.offset.dx + details.delta.dx;
          double newY = dashboardWidgetModel.offset.dy + details.delta.dy;

          newX = newX.clamp(0.0, maxX);
          newY = newY.clamp(0.0, maxY);

          controller.updateWidgetOffset(dashboardWidgetModel.id, Offset(newX, newY));
        },
        onPanEnd: (_) {
          Offset snappedPos =
              _snapToGrid(controller.getSpecificWidgetModel(dashboardWidgetModel.id)!.offset, controller.unitSize);

          final screenSize = MediaQuery.of(context).size;
          double maxX = screenSize.width - dashboardWidgetModel.w * controller.unitSize;
          double maxY = screenSize.height - dashboardWidgetModel.h * controller.unitSize;

          double clampedX = snappedPos.dx.clamp(0.0, maxX);
          double clampedY = snappedPos.dy.clamp(0.0, maxY);
          snappedPos = Offset(clampedX, clampedY);

          if (_isPositionFree(
              snappedPos, dashboardWidgetModel.id, controller.dashboardWidgetModels, controller.unitSize)) {
            controller.updateWidgetOffset(dashboardWidgetModel.id, snappedPos);
          } else {
            controller.updateWidgetOffset(dashboardWidgetModel.id, controller.oldPosition);
          }
        },
        child: Container(
          width: dashboardWidgetModel.w * controller.unitSize,
          height: dashboardWidgetModel.h * controller.unitSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: dashboardWidgetModel.color,
          ),
          // child: child,
        ),
      ),
    );
  }
}
