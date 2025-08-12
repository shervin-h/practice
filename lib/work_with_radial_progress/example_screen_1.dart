import 'package:flutter/material.dart';
import 'package:radial_progress/radial_progress.dart';

class ExampleScreen1 extends StatelessWidget {
  const ExampleScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Progress Demo'),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RadialProgressWidget(
                    percent: 0.35,
                    diameter: 180,
                    bgLineColor: Colors.cyan.withOpacity(0.2),
                    progressLineWidth: 16,
                    startAngle: StartAngle.top,
                    // progressLineColors: const [
                    //   Colors.pinkAccent,
                    //   Colors.pink,
                    //   Colors.purpleAccent,
                    //   Colors.purple
                    // ],
                    centerChild: const Text(
                      '\$ 547.52 - \$ 800.0',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const DemoItem(title: 'Item 1', amount: '-50.0'),
                const DemoItem(title: 'Item 2', amount: '-53.35'),
                const DemoItem(title: 'Item 3', amount: '-25.7'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DemoItem extends StatelessWidget {
  const DemoItem({
    required this.title,
    required this.amount,
    super.key,
  });

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$amount \$',
            maxLines: 1,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
