import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/practice_for_dashboard_generator/dashboard_generator.dart';
import 'package:practice/practice_for_dashboard_generator/tt.dart';
import 'package:practice/work_with_bloc/counter_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => CounterCubit(0),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Yekan',
        primarySwatch: Colors.blue,
      ),
      // home: const WorkWithAnimations(),
      // home: const WorkWithAnimationController(),
      // home: const WorkWithWidgets(),
      // home: const WorkWithBloc(),
      // home: const WorkWithRadialProgress(),
      // home: const WorkWithClippers(),
      // home: const WorkWithProgressLineScreen(),
      // home: const PracticeDesignScreen(),
      // home: const WorkWithOutlinePieChartScreen(),
      // home: const WorkWithCropper(),
      // home: PracticeForDashboardGenerator(),
      // home: const SnapToGridExample(),
      // home: const MultiSnapGridExample(),
      // home: const DynamicSnapGridExample(),
      // home: const DashboardGenerator(),
      home: const Tt(),
    );
  }
}
