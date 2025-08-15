import 'package:flutter/material.dart';
import 'package:practice/practice_for_dashboard_generator/dynamic_snap_grid_example.dart';
import 'package:practice/practice_for_dashboard_generator/multi_snap_grid_example.dart';
import 'package:practice/practice_for_dashboard_generator/practice_for_dashboard_generator.dart';
import 'package:practice/practice_for_dashboard_generator/snap_to_grid_example.dart';

class DashboardGenerator extends StatelessWidget {
  const DashboardGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
            ),
            children: [
              GridItem(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const SnapToGridExample();
                      },
                    ),
                  );
                },
                title: 'Snap To Grid Example',
                color: Colors.blue,
              ),
              GridItem(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const MultiSnapGridExample();
                      },
                    ),
                  );
                },
                title: 'Multi Snap Grid Example',
                color: Colors.red,
              ),
              GridItem(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const DynamicSnapGridExample();
                      },
                    ),
                  );
                },
                title: 'Dynamic Snap Grid Example',
                color: Colors.yellow,
              ),
              GridItem(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const PracticeForDashboardGenerator();
                      },
                    ),
                  );
                },
                title: 'Practice For Dashboard Generator',
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    required this.onTap,
    required this.title,
    required this.color,
    super.key,
  });

  final void Function() onTap;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 4)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
