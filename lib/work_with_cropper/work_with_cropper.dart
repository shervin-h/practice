import 'package:flutter/material.dart';

class WorkWithCropper extends StatelessWidget {
  const WorkWithCropper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('cropper'),
        ),
      ),
    );
  }
}
