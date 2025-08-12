import 'package:flutter/material.dart';
import 'package:radial_progress/radial_progress.dart';

class ExampleScreen2 extends StatefulWidget {
  const ExampleScreen2({super.key});

  @override
  State<ExampleScreen2> createState() => _ExampleScreen2State();
}

class _ExampleScreen2State extends State<ExampleScreen2> {

  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Progress Demo'),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: Center(
          child: RadialProgressWidget(
            percent: 0.92,
            diameter: 180,
            progressLineWidth: 40,
            startAngle: StartAngle.bottom,
            enableAnimation: true,
            animationDuration: const Duration(seconds: 5),
            progressLineColors: const [
              Colors.purple,
              Colors.purpleAccent,
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.lightGreenAccent,
              Colors.lightGreen,
              Colors.green,
            ],
            callback: (value) {
              setState(() {
                _value = value;
              });
            },
            centerChild: Text(
              '${(_value * 100).toInt()} %',
              maxLines: 1,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
