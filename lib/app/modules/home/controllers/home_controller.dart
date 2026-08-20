import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/expense_controller.dart';
import '../../../data/models/expense.dart';
import '../../main/controllers/main_controller.dart';

class HomeController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final AuthController authController = Get.find<AuthController>();

  MainController get _main => Get.find<MainController>();

  String get greetingName => authController.user.value?.displayName ?? '';

  Future<void> refreshData() => expenseController.refreshExpenses();

  void retry() => expenseController.retry();

  void seeAllExpenses() => _main.goToExpenses();

  Future<void> addExpense() => _main.openExpenseForm();

  Future<void> editExpense(Expense expense) =>
      _main.openExpenseForm(expense: expense);
}
