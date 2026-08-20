import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mini_expense_tracker/app/controllers/expense_controller.dart';
import 'package:mini_expense_tracker/app/data/enums/app_enums.dart';
import 'package:mini_expense_tracker/app/data/repositories/expense_repository.dart';
import 'package:mini_expense_tracker/app/modules/expense_list/controllers/expense_list_controller.dart';

import 'expense_controller_test.dart' show FakeExpenseRepository, buildExpense;

void main() {
  late FakeExpenseRepository repository;
  late ExpenseController expenseController;
  late ExpenseListController listController;

  setUp(() async {
    Get.testMode = true;
    repository = FakeExpenseRepository(
      rows: [
        buildExpense(
          id: '1',
          amount: 20,
          date: DateTime(2026, 8, 10),
          category: ExpenseCategory.food,
          note: 'Coffee with Sam',
        ),
        buildExpense(
          id: '2',
          amount: 60,
          date: DateTime(2026, 8, 9),
          category: ExpenseCategory.bills,
          note: 'Electricity',
        ),
        buildExpense(
          id: '3',
          amount: 15,
          date: DateTime(2026, 8, 8),
          category: ExpenseCategory.food,
        ),
      ],
    );
    Get.put<ExpenseRepository>(repository);
    expenseController = Get.put(ExpenseController());
    await expenseController.loadExpenses();
    listController = ExpenseListController();
  });

  tearDown(Get.reset);

  test('shows every expense when no filter is active', () {
    expect(listController.filteredExpenses.length, 3);
    expect(listController.filteredTotal, 95);
    expect(listController.hasActiveFilter, isFalse);
  });

  test('filters by category', () {
    listController.selectCategory(ExpenseCategory.food);

    expect(listController.filteredExpenses.map((e) => e.id), ['1', '3']);
    expect(listController.filteredTotal, 35);
    expect(listController.hasActiveFilter, isTrue);
  });

  test('search matches the note, case-insensitively', () {
    listController.onSearchChanged('coffee');

    expect(listController.filteredExpenses.single.id, '1');
  });

  test('search also matches the category label', () {
    listController.onSearchChanged('bills');

    expect(listController.filteredExpenses.single.id, '2');
  });

  test('category filter and search combine', () {
    listController.selectCategory(ExpenseCategory.food);
    listController.onSearchChanged('electricity');

    expect(listController.filteredExpenses, isEmpty);
  });

  test('clearFilters resets both filters', () {
    listController.selectCategory(ExpenseCategory.bills);
    listController.onSearchChanged('elec');

    listController.clearFilters();

    expect(listController.hasActiveFilter, isFalse);
    expect(listController.filteredExpenses.length, 3);
    expect(listController.searchController.text, isEmpty);
  });
}
