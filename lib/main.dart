import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/dashboard_practice/main_screen.dart';
import 'package:practice/dashboard_practice/my_example/my_dashboard_page.dart';
import 'package:practice/deepseek_dashboard/deepseek_dashboard_screen.dart';
import 'package:practice/play_for_make_dashboard/play_for_make_dashboard_screen.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/bindings/custom_dashboard_generator_bindings.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/screens/example2_screen.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/screens/custom_dashboard_generator_screen.dart';
import 'package:practice/shervin_dashboard/shervin_dashboard_screen.dart';
import 'package:practice/work_with_bloc/counter_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return GetMaterialApp(
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
      // home: const CustomDashboardGenerator(),
      initialRoute: '/deepseek_dashboard',
      getPages: [
        GetPage(
          name: '/custom_dashboard_generator',
          page: () => const CustomDashboardGeneratorScreen(),
          binding: CustomDashboardGeneratorBindings(),
        ),
        GetPage(
          name: '/example2screen',
          page: () => const DashboardBuilderPage(),
        ),
        GetPage(
          name: '/main_dashboard',
          page: () => const MainScreen(),
        ),

        GetPage(
          name: '/my_dashboard',
          page: () => const MyDashboardPage(),
        ),
        GetPage(
          name: '/play_for_make_dashboard',
          page: () => const PlayForMakeDashboardScreen(),
        ),
        GetPage(
          name: '/shervin_dashboard',
          page: () => const ShervinDashboardScreen(),
        ),
        GetPage(
          name: '/deepseek_dashboard',
          page: () => DeepseekDashboardScreen(),
        ),
      ],
    );
  }
}
