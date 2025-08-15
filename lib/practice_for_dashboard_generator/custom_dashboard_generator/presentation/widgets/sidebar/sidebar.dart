import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/controllers/custom_dashboard_generator_controller.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/widgets/sidebar/close_sidebar.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/widgets/sidebar/sidebar_draggable_palette.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomDashboardGeneratorController>();
    final items = controller.sidebarItems;
    return Container(
      width: 250,
      // height: 600,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return SidebarDraggablePalette(paletteModel: items[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
          ),
          const SizedBox(height: 20),
          const CloseSidebar(),
        ],
      ),
    );
  }
}
