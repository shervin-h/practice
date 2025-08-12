import 'package:flutter/material.dart';
import 'package:progress_line/progress_line.dart';

class WorkWithProgressLineScreen extends StatefulWidget {
  const WorkWithProgressLineScreen({super.key});

  @override
  State<WorkWithProgressLineScreen> createState() => _WorkWithProgressLineScreenState();
}

class _WorkWithProgressLineScreenState extends State<WorkWithProgressLineScreen> {

  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Bar'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(children: [],),
            ProgressLineWidget(percent: 0.4),
            const SizedBox(height: 20),
            ProgressLineWidget(
              percent: 0.9,
              lineWidth: 20,
              lineColors: const [
                Colors.purple,
                Colors.pink,
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.lightGreenAccent,
                Colors.lightGreen,
                Colors.green,
              ],
              bgColor: Colors.grey.withOpacity(0.4),
              innerPadding: const EdgeInsets.all(20),
              outerPadding: const EdgeInsets.only(left: 16),
              width: 180,
              height: 100,
              animationDuration: const Duration(seconds: 5),
              start: Text(
                (_value * 100).toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              end: Text(
                ((1 - _value) * 100).toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              callback: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
