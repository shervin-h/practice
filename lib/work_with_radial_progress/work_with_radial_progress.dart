import 'package:flutter/material.dart';
import 'package:practice/work_with_radial_progress/example_screen_1.dart';
import 'package:practice/work_with_radial_progress/example_screen_2.dart';
import 'package:practice/work_with_radial_progress/example_screen_3.dart';

class WorkWithRadialProgress extends StatelessWidget {
  const WorkWithRadialProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Progress Demo'),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: GridView(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          children: [
            GridItem(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExampleScreen1(),
                  ),
                );
              },
              title: 'Example 1',
              color: Colors.cyan,
            ),
            GridItem(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExampleScreen2(),
                  ),
                );
              },
              title: 'Example 2',
              color: Colors.grey,
            ),
            GridItem(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExampleScreen3(),
                  ),
                );
              },
              title: 'Example 3',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    required this.title,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String title;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
        ),
        child: Text(
          title,
          maxLines: 2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
