import 'package:get/get.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/presentation/controllers/custom_dashboard_generator_controller.dart';

class CustomDashboardGeneratorBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomDashboardGeneratorController>(() => CustomDashboardGeneratorController());
  }
}
