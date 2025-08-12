import 'package:flutter/material.dart';

class PracticeForDashboardGenerator extends StatefulWidget {
  const PracticeForDashboardGenerator({super.key});

  @override
  State<PracticeForDashboardGenerator> createState() => _PracticeForDashboardGeneratorState();
}

class _PracticeForDashboardGeneratorState extends State<PracticeForDashboardGenerator> {
  double x = 20;
  double y = 500;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: x,
                top: y,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      x += details.delta.dx;
                      y += details.delta.dy;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.cyan,
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
