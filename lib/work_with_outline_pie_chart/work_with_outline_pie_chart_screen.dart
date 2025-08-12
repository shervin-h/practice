import 'package:flutter/material.dart';
import 'package:outline_pie_chart/outline_pie_chart.dart';

class WorkWithOutlinePieChartScreen extends StatelessWidget {
  const WorkWithOutlinePieChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outline Pie Chart Demo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PieChartWidget(
          data: [
            PieData(percentage: 100, color: Colors.cyan),
            PieData(percentage: 50, color: Colors.red),
            PieData(percentage: 30, color: Colors.yellow),
            PieData(percentage: 50, color: Colors.purple),
            PieData(percentage: 40, color: Colors.orange),
          ],
          diameter: 300,
          enableAnimation: true,
          animationDuration: const Duration(seconds: 2),
          strokeWidth: 40,
          gap: 4,
          isRTL: false,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Asset Value',
                style: TextStyle(
                  fontFamily: '',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF757575),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '2,798,625',
                style: TextStyle(
                  fontFamily: '',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              Text(
                '\$',
                style: TextStyle(
                  fontFamily: '',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


