import 'package:curve_clipper/curve_clipper.dart';
import 'package:flutter/material.dart';

class WorkWithClippers extends StatelessWidget {
  const WorkWithClippers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomClipperWidget(
                mode: ClipperMode.convex,
                heightFromOrigin: 20,
                curvePoint: 80,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
