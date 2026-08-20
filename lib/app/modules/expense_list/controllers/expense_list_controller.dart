import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controllers/expense_controller.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/enums/app_enums.dart';
import '../../../data/models/expense.dart';
import '../../main/controllers/main_controller.dart';

class ExpenseListController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();

  final TextEditingController searchController = TextEditingController();

  final Rx<ExpenseCategory?> selectedCategory = Rx<ExpenseCategory?>(null);
  final RxString searchQuery = ''.obs;

  MainController get _main => Get.find<MainController>();

  bool get hasActiveFilter =>
      selectedCategory.value != null || searchQuery.value.trim().isNotEmpty;

  List<Expense> get filteredExpenses {
    final category = selectedCategory.value;
    final query = searchQuery.value.trim().toLowerCase();

    return expenseController.expenses.where((expense) {
      if (category != null && expense.category != category) return false;
      if (query.isEmpty) return true;
      final note = expense.note?.toLowerCase() ?? '';
      return note.contains(query) ||
          expense.category.label.toLowerCase().contains(query);
    }).toList();
  }

  double get filteredTotal =>
      filteredExpenses.fold<double>(0, (sum, expense) => sum + expense.amount);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void selectCategory(ExpenseCategory? category) =>
      selectedCategory.value = category;

  void clearFilters() {
    selectedCategory.value = null;
    clearSearch();
  }

  Future<void> refreshData() => expenseController.refreshExpenses();

  void retry() => expenseController.retry();

  Future<void> addExpense() => _main.openExpenseForm();

  Future<void> editExpense(Expense expense) =>
      _main.openExpenseForm(expense: expense);

  Future<void> deleteExpense(Expense expense) async {
    final confirmed = await AppDialog.confirm(
      title: AppStrings.deleteExpense,
      message: AppStrings.deleteExpenseMessage,
    );
    if (!confirmed) return;

    final result = await expenseController.remove(expense.id);
    if (result.failed) {
      AppSnackbar.error(result.error ?? AppStrings.genericError);
      return;
    }
    AppSnackbar.success(AppStrings.expenseDeleted);
  }
}
