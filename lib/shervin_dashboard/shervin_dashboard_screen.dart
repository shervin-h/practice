import 'package:flutter/material.dart';
import 'package:practice/shervin_dashboard/dashboard.dart';


class ShervinDashboardScreen extends StatelessWidget {
  const ShervinDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GridDemoPage()),
    );
  }
}
