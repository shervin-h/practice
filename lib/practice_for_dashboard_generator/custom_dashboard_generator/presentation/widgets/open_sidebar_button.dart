import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/controllers/custom_dashboard_generator_controller.dart';

class OpenSidebarButton extends StatelessWidget {
  const OpenSidebarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomDashboardGeneratorController>();
    return PositionedDirectional(
      start: 20,
      bottom: 20,
      child: InkWell(
        onTap: () => controller.openSidebar(),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.purple,
          ),
          child: const Icon(Icons.add, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}
