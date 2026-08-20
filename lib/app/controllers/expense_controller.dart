import 'package:get/get.dart';

import '../core/values/app_strings.dart';
import '../data/enums/app_enums.dart';
import '../data/models/category_total.dart';
import '../data/models/expense.dart';
import '../data/models/result.dart';
import '../data/repositories/expense_repository.dart';

class ExpenseController extends GetxController {
  final ExpenseRepository _repo = Get.find<ExpenseRepository>();

  final RxList<Expense> expenses = <Expense>[].obs;
  final Rx<LoadingState> loadingState = LoadingState.initial.obs;
  final RxString errorMessage = ''.obs;

  final Rx<String?> deletingId = Rx<String?>(null);

  bool get hasExpenses => expenses.isNotEmpty;

  double get total => _sumOf(expenses);

  double get currentMonthTotal => _sumOf(_thisMonth);

  int get currentMonthCount => _thisMonth.length;

  List<Expense> get recentExpenses => expenses.take(5).toList();

  List<CategoryTotal> get categoryTotals {
    final amountPerCategory = <ExpenseCategory, double>{};
    for (final expense in expenses) {
      final soFar = amountPerCategory[expense.category] ?? 0;
      amountPerCategory[expense.category] = soFar + expense.amount;
    }

    final totals = amountPerCategory.entries
        .map((entry) => CategoryTotal(category: entry.key, amount: entry.value))
        .toList();
    totals.sort((a, b) => b.amount.compareTo(a.amount));
    return totals;
  }

  List<ExpenseCategory> get usedCategories =>
      categoryTotals.map((total) => total.category).toList();

  List<Expense> get _thisMonth {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .toList();
  }

  double _sumOf(List<Expense> list) =>
      list.fold<double>(0, (sum, expense) => sum + expense.amount);

  Future<void> ensureLoaded() async {
    final needsLoading =
        loadingState.value == LoadingState.initial ||
        loadingState.value == LoadingState.error;
    if (needsLoading) await loadExpenses();
  }

  Future<void> loadExpenses({bool showLoader = true}) async {
    if (showLoader) loadingState.value = LoadingState.loading;
    errorMessage.value = '';

    final result = await _repo.fetchExpenses();

    if (result.failed) {
      errorMessage.value = result.error ?? AppStrings.genericError;
      loadingState.value = LoadingState.error;
      return;
    }

    expenses.assignAll(result.data ?? const <Expense>[]);
    _sortNewestFirst();
    _updateEmptyState();
  }

  Future<void> refreshExpenses() => loadExpenses(showLoader: false);

  void retry() => loadExpenses();

  Future<Result<Expense>> create({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  }) async {
    final result = await _repo.createExpense(
      amount: amount,
      category: category,
      date: date,
      note: note,
    );

    final created = result.data;
    if (result.success && created != null) {
      expenses.add(created);
      _sortNewestFirst();
      _updateEmptyState();
    }
    return result;
  }

  Future<Result<Expense>> edit(Expense expense) async {
    final result = await _repo.updateExpense(expense);

    final saved = result.data;
    if (result.success && saved != null) {
      final index = expenses.indexWhere((e) => e.id == saved.id);
      if (index == -1) {
        expenses.add(saved);
      } else {
        expenses[index] = saved;
      }
      _sortNewestFirst();
      _updateEmptyState();
    }
    return result;
  }

  Future<Result<void>> remove(String id) async {
    deletingId.value = id;
    final result = await _repo.deleteExpense(id);
    deletingId.value = null;

    if (result.success) {
      expenses.removeWhere((e) => e.id == id);
      _updateEmptyState();
    }
    return result;
  }

  Expense? byId(String id) {
    for (final expense in expenses) {
      if (expense.id == id) return expense;
    }
    return null;
  }

  void clear() {
    expenses.clear();
    errorMessage.value = '';
    deletingId.value = null;
    loadingState.value = LoadingState.initial;
  }

  void _sortNewestFirst() {
    final veryOld = DateTime.fromMillisecondsSinceEpoch(0);
    expenses.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      if (byDate != 0) return byDate;
      return (b.createdAt ?? veryOld).compareTo(a.createdAt ?? veryOld);
    });
    expenses.refresh();
  }

  void _updateEmptyState() {
    loadingState.value = expenses.isEmpty
        ? LoadingState.empty
        : LoadingState.loaded;
  }
}
