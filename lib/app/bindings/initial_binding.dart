import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/expense_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/expense_repository.dart';

class InitialBinding extends Bindings {
  InitialBinding(this._prefs);

  final SharedPreferences _prefs;

  @override
  void dependencies() {
    Get.put<AuthRepository>(FirebaseAuthRepository(), permanent: true);
    Get.put<ExpenseRepository>(FirebaseExpenseRepository(), permanent: true);

    Get.put<ThemeController>(ThemeController(_prefs), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ExpenseController>(ExpenseController(), permanent: true);
  }
}
