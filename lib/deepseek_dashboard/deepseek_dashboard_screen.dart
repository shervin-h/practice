import 'package:flutter/material.dart';
import 'package:practice/deepseek_dashboard/src/dashboard_controller.dart';
import 'package:practice/deepseek_dashboard/src/dashboard_grid.dart';
import 'package:practice/deepseek_dashboard/src/dashboard_sidebar.dart';
import 'package:practice/deepseek_dashboard/src/drag_position_notifier.dart';

class DeepseekDashboardScreen extends StatelessWidget {
  DeepseekDashboardScreen({super.key});

  final DashboardController controller = DashboardController(gridSize: 50, columns: 12);
  final DragPositionNotifier dragPositionNotifier = DragPositionNotifier();

  final List<SidebarWidget> sidebarWidgets = [
    SidebarWidget(
      name: 'Text Widget',
      builder: (context) => Container(
        padding: EdgeInsets.all(8),
        child: Text('Sample Text Widget', style: TextStyle(fontSize: 16)),
      ),
      defaultWidth: 4,
      defaultHeight: 2,
    ),
    SidebarWidget(
      name: 'Chart Widget',
      builder: (context) => Container(
        padding: EdgeInsets.all(8),
        color: Colors.orange[100],
        child: Center(child: Text('Chart Placeholder', style: TextStyle(fontSize: 14))),
      ),
      defaultWidth: 6,
      defaultHeight: 4,
    ),
    SidebarWidget(
      name: 'Image Widget',
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Icon(Icons.image, size: 32)),
      ),
      defaultWidth: 3,
      defaultHeight: 3,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Builder'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: controller.clear,
          ),
        ],
      ),
      body: Row(
        children: [
          DashboardSidebar(
            widgets: sidebarWidgets,
          ),
          Expanded(
            child: DashboardGrid(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
