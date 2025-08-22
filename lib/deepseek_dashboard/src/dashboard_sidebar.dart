import 'package:flutter/material.dart';
import 'dashboard_item.dart';

class SidebarWidget {
  final String name;
  final WidgetBuilder builder;
  final int defaultWidth;
  final int defaultHeight;
  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;

  SidebarWidget({
    required this.name,
    required this.builder,
    this.defaultWidth = 2,
    this.defaultHeight = 2,
    this.minWidth = 1,
    this.maxWidth = 12,
    this.minHeight = 1,
    this.maxHeight = 12,
  });
}

class DashboardSidebar extends StatelessWidget {
  final List<SidebarWidget> widgets;
  final double width;

  const DashboardSidebar({
    Key? key,
    required this.widgets,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Colors.grey[200],
      child: ListView(
        children: widgets.map((sidebarWidget) {
          return Draggable<DashboardItem>(
            data: DashboardItem(
              id: 'template_${sidebarWidget.name}',
              child: sidebarWidget.builder(context),
              x: 0,
              y: 0,
              width: sidebarWidget.defaultWidth,
              height: sidebarWidget.defaultHeight,
              minWidth: sidebarWidget.minWidth,
              maxWidth: sidebarWidget.maxWidth,
              minHeight: sidebarWidget.minHeight,
              maxHeight: sidebarWidget.maxHeight,
            ),
            feedback: Material(
              elevation: 4,
              child: Container(
                width: sidebarWidget.defaultWidth * 50.0,
                height: sidebarWidget.defaultHeight * 50.0,
                color: Colors.white,
                child: sidebarWidget.builder(context),
              ),
            ),
            childWhenDragging: Container(
              color: Colors.grey[300],
              child: ListTile(
                title: Text(sidebarWidget.name),
                trailing: Icon(Icons.drag_handle),
              ),
            ),
            child: ListTile(
              title: Text(sidebarWidget.name),
              trailing: Icon(Icons.drag_handle),
            ),
          );
        }).toList(),
      ),
    );
  }
}