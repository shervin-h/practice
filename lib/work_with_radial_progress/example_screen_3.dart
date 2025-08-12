import 'package:flutter/material.dart';
import 'package:radial_progress/radial_progress.dart';

class ExampleScreen3 extends StatefulWidget {
  const ExampleScreen3({super.key});

  @override
  State<ExampleScreen3> createState() => _ExampleScreen3State();
}

class _ExampleScreen3State extends State<ExampleScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Progress Demo'),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const RadialSample1(),
                RadialProgressWidget(
                  percent: 0.73,
                  diameter: 85,
                  progressLineWidth: 40,
                  startAngle: StartAngle.bottom,
                  enableAnimation: true,
                  animationDuration: const Duration(seconds: 2),
                  centerChild: const Text(
                    '-',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RadialProgressWidget(
                  percent: 0.23,
                  diameter: 100,
                  progressLineWidth: 24,
                  startAngle: StartAngle.start,
                  enableAnimation: true,
                  animationDuration: const Duration(seconds: 2),
                  progressLineColors: const [
                    Colors.lightBlueAccent,
                    Colors.lightBlue,
                    Colors.blue,
                  ],
                  centerChild: const Text(
                    '23 %',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RadialProgressWidget(
                  percent: 0.73,
                  diameter: 95,
                  progressLineWidth: 12,
                  startAngle: StartAngle.end,
                  enableAnimation: true,
                  animationDuration: const Duration(seconds: 2),
                  centerChild: Container(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadialSample2(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// sample 1 widget
class RadialSample1 extends StatefulWidget {
  const RadialSample1({super.key});

  @override
  State<RadialSample1> createState() => _RadialSample1State();
}

class _RadialSample1State extends State<RadialSample1> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return RadialProgressWidget(
      percent: 0.92,
      diameter: 185,
      progressLineWidth: 32,
      startAngle: StartAngle.top,
      enableAnimation: true,
      animationDuration: const Duration(seconds: 4),
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
      centerChild: Text(
        '${(_value * 100).toInt()} %',
        maxLines: 1,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      callback: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }
}

// sample 2 widget
class RadialSample2 extends StatefulWidget {
  const RadialSample2({super.key});

  @override
  State<RadialSample2> createState() => _RadialSample2State();
}

class _RadialSample2State extends State<RadialSample2> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return RadialProgressWidget(
      percent: 0.57,
      diameter: 300,
      progressLineWidth: 24,
      startAngle: StartAngle.top,
      enableAnimation: true,
      animationDuration: const Duration(seconds: 5),
      progressLineColors: [
        Colors.grey.shade600,
      ],
      centerChild: Text(
        (_value < 0.2)
            ? 'line 1\nsome description in line 2\nor each widget\n${(_value * 100).toInt()} %'
            : (_value < 0.3)
                ? '🙂'
                : (_value < 0.3)
                    ? '🙃'
                    : (_value < 0.4)
                        ? '😉'
                        : (_value < 0.5)
                            ? '😌'
                            : '🤩',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (_value < 0.2) ? 20 : 100,
          fontWeight: FontWeight.bold,
        ),
      ),
      callback: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }
}
