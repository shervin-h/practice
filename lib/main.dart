import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/practice_designs/practice_design_screen.dart';
import 'package:practice/practice_for_dashboard_generator/dynamic_snap_grid_example.dart';
import 'package:practice/practice_for_dashboard_generator/multi_snap_grid_example.dart';
import 'package:practice/practice_for_dashboard_generator/practice_for_dashboard_generator.dart';
import 'package:practice/practice_for_dashboard_generator/resizable_draggable_grid.dart';
import 'package:practice/practice_for_dashboard_generator/snap_to_grid_example.dart';
import 'package:practice/work_with_animations/work_with_animation_controller.dart';
import 'package:practice/work_with_animations/work_with_animations.dart';
import 'package:practice/work_with_bloc/counter_cubit.dart';
import 'package:practice/work_with_bloc/work_with_bloc.dart';
import 'package:practice/work_with_clippers/work_with_clippers.dart';
import 'package:practice/work_with_cropper/work_with_cropper.dart';
import 'package:practice/work_with_outline_pie_chart/work_with_outline_pie_chart_screen.dart';
import 'package:practice/work_with_packages/work_with_packages.dart';
import 'package:practice/work_with_progress_bar/work_with_progress_bar_screen.dart';
import 'package:practice/work_with_radial_progress/work_with_radial_progress.dart';
import 'package:practice/work_with_widgets/work_with_widgets.dart';
import 'package:provider/provider.dart';

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
      // home: const WorkWithPackages(),
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
      home: const ResizableDraggableGrid(),
    );
  }
}
