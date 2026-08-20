import 'package:get/get.dart';

import '../../../controllers/expense_controller.dart';
import '../../../data/models/expense.dart';
import '../../../routes/app_routes.dart';

class MainController extends GetxController {
  static const int homeTab = 0;
  static const int expensesTab = 1;
  static const int profileTab = 2;

  final ExpenseController _expenseController = Get.find<ExpenseController>();

  final RxInt currentIndex = homeTab.obs;

  @override
  void onInit() {
    super.onInit();
    _expenseController.ensureLoaded();
  }

  void changeTab(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
  }

  void goToExpenses() => changeTab(expensesTab);

  Future<void> openExpenseForm({Expense? expense}) async {
    await Get.toNamed(Routes.expenseForm, arguments: expense);
  }
}
