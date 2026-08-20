import 'package:get/get.dart';

import '../../expense_list/controllers/expense_list_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ExpenseListController>(() => ExpenseListController());
  }
}
