import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/controllers/custom_dashboard_generator_controller.dart';

class CloseSidebar extends StatelessWidget {
  const CloseSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomDashboardGeneratorController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: InkWell(
          onTap: () {
            controller.closeSidebar();
          },
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withAlpha(40), width: 1.5),
            ),
            child: const Text('Close Palette'),
          ),
        ),
      ),
    );
  }
}
