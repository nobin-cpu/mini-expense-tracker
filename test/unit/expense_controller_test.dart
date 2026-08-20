import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mini_expense_tracker/app/controllers/expense_controller.dart';
import 'package:mini_expense_tracker/app/data/enums/app_enums.dart';
import 'package:mini_expense_tracker/app/data/models/expense.dart';
import 'package:mini_expense_tracker/app/data/models/result.dart';
import 'package:mini_expense_tracker/app/data/repositories/expense_repository.dart';

class FakeExpenseRepository implements ExpenseRepository {
  FakeExpenseRepository({this.rows = const []});

  List<Expense> rows;
  String? nextError;
  int fetchCount = 0;

  @override
  Future<Result<List<Expense>>> fetchExpenses() async {
    fetchCount++;
    if (nextError != null) return Result.fail(nextError);
    return Result.ok(List<Expense>.from(rows));
  }

  @override
  Future<Result<Expense>> createExpense({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  }) async {
    if (nextError != null) return Result.fail(nextError);
    final created = Expense(
      id: 'new-${rows.length + 1}',
      userId: 'user-1',
      amount: amount,
      category: category,
      date: date,
      note: note,
      createdAt: DateTime(2026, 1, 1),
    );
    rows = [...rows, created];
    return Result.ok(created);
  }

  @override
  Future<Result<Expense>> updateExpense(Expense expense) async {
    if (nextError != null) return Result.fail(nextError);
    return Result.ok(expense);
  }

  @override
  Future<Result<void>> deleteExpense(String id) async {
    if (nextError != null) return Result.fail(nextError);
    rows = rows.where((e) => e.id != id).toList();
    return const Result.ok(null);
  }
}

Expense buildExpense({
  required String id,
  required double amount,
  required DateTime date,
  ExpenseCategory category = ExpenseCategory.food,
  String? note,
}) {
  return Expense(
    id: id,
    userId: 'user-1',
    amount: amount,
    category: category,
    date: date,
    note: note,
    createdAt: date,
  );
}

void main() {
  late FakeExpenseRepository repository;
  late ExpenseController controller;

  setUp(() {
    Get.testMode = true;
    repository = FakeExpenseRepository();
    Get.put<ExpenseRepository>(repository);
    controller = ExpenseController();
  });

  tearDown(Get.reset);

  test('starts in the initial state', () {
    expect(controller.loadingState.value, LoadingState.initial);
    expect(controller.hasExpenses, isFalse);
  });

  test('loads expenses and reports the empty state for no rows', () async {
    await controller.loadExpenses();

    expect(controller.loadingState.value, LoadingState.empty);
    expect(controller.expenses, isEmpty);
  });

  test('loads expenses newest first', () async {
    repository.rows = [
      buildExpense(id: 'old', amount: 10, date: DateTime(2026, 1, 5)),
      buildExpense(id: 'new', amount: 20, date: DateTime(2026, 8, 5)),
      buildExpense(id: 'mid', amount: 30, date: DateTime(2026, 4, 5)),
    ];

    await controller.loadExpenses();

    expect(controller.loadingState.value, LoadingState.loaded);
    expect(controller.expenses.map((e) => e.id).toList(), [
      'new',
      'mid',
      'old',
    ]);
  });

  test('surfaces the error state and message when loading fails', () async {
    repository.nextError = 'No internet connection.';

    await controller.loadExpenses();

    expect(controller.loadingState.value, LoadingState.error);
    expect(controller.errorMessage.value, 'No internet connection.');
    expect(controller.expenses, isEmpty);
  });

  test('ensureLoaded only hits the repository once on success', () async {
    await controller.ensureLoaded();
    await controller.ensureLoaded();

    expect(repository.fetchCount, 1);
  });

  test('ensureLoaded retries after a failure', () async {
    repository.nextError = 'boom';
    await controller.ensureLoaded();
    repository.nextError = null;
    await controller.ensureLoaded();

    expect(repository.fetchCount, 2);
    expect(controller.loadingState.value, LoadingState.empty);
  });

  test('totals cover all expenses and the current month only', () async {
    final now = DateTime.now();
    repository.rows = [
      buildExpense(
        id: '1',
        amount: 100,
        date: DateTime(now.year, now.month, 1),
      ),
      buildExpense(
        id: '2',
        amount: 50.5,
        date: DateTime(now.year, now.month, 2),
      ),
      buildExpense(
        id: '3',
        amount: 25,
        date: DateTime(now.year - 1, now.month, 3),
      ),
    ];

    await controller.loadExpenses();

    expect(controller.total, 175.5);
    expect(controller.currentMonthTotal, 150.5);
    expect(controller.currentMonthCount, 2);
  });

  test('recentExpenses returns at most five rows', () async {
    repository.rows = [
      for (var day = 1; day <= 8; day++)
        buildExpense(
          id: '$day',
          amount: day * 1.0,
          date: DateTime(2026, 8, day),
        ),
    ];

    await controller.loadExpenses();

    expect(controller.recentExpenses.length, 5);
    expect(controller.recentExpenses.first.id, '8');
  });

  test('categoryTotals groups by category, biggest first', () async {
    repository.rows = [
      buildExpense(
        id: '1',
        amount: 10,
        date: DateTime(2026, 8, 1),
        category: ExpenseCategory.food,
      ),
      buildExpense(
        id: '2',
        amount: 40,
        date: DateTime(2026, 8, 2),
        category: ExpenseCategory.bills,
      ),
      buildExpense(
        id: '3',
        amount: 15,
        date: DateTime(2026, 8, 3),
        category: ExpenseCategory.food,
      ),
    ];

    await controller.loadExpenses();
    final totals = controller.categoryTotals;

    expect(totals.length, 2);
    expect(totals.first.category, ExpenseCategory.bills);
    expect(totals.first.amount, 40);
    expect(totals.last.category, ExpenseCategory.food);
    expect(totals.last.amount, 25);
    expect(controller.usedCategories, [
      ExpenseCategory.bills,
      ExpenseCategory.food,
    ]);
  });

  test('create adds the new expense in the right position', () async {
    repository.rows = [
      buildExpense(id: 'existing', amount: 10, date: DateTime(2026, 1, 1)),
    ];
    await controller.loadExpenses();

    final result = await controller.create(
      amount: 33,
      category: ExpenseCategory.health,
      date: DateTime(2026, 9, 1),
      note: 'Pharmacy',
    );

    expect(result.success, isTrue);
    expect(controller.expenses.length, 2);
    expect(controller.expenses.first.amount, 33);
    expect(controller.loadingState.value, LoadingState.loaded);
  });

  test('create leaves the list untouched when the repository fails', () async {
    await controller.loadExpenses();
    repository.nextError = 'Permission denied.';

    final result = await controller.create(
      amount: 5,
      category: ExpenseCategory.other,
      date: DateTime(2026, 2, 2),
    );

    expect(result.failed, isTrue);
    expect(result.error, 'Permission denied.');
    expect(controller.expenses, isEmpty);
  });

  test('edit replaces the row in place', () async {
    repository.rows = [
      buildExpense(id: 'e1', amount: 10, date: DateTime(2026, 5, 5)),
    ];
    await controller.loadExpenses();

    final updated = controller.expenses.first.copyWith(
      amount: 99,
      category: ExpenseCategory.shopping,
    );
    final result = await controller.edit(updated);

    expect(result.success, isTrue);
    expect(controller.expenses.length, 1);
    expect(controller.expenses.first.amount, 99);
    expect(controller.expenses.first.category, ExpenseCategory.shopping);
    expect(controller.total, 99);
  });

  test('remove deletes the row and flips back to the empty state', () async {
    repository.rows = [
      buildExpense(id: 'e1', amount: 10, date: DateTime(2026, 5, 5)),
    ];
    await controller.loadExpenses();

    final result = await controller.remove('e1');

    expect(result.success, isTrue);
    expect(controller.expenses, isEmpty);
    expect(controller.loadingState.value, LoadingState.empty);
    expect(controller.deletingId.value, isNull);
  });

  test('remove keeps the row when the repository fails', () async {
    repository.rows = [
      buildExpense(id: 'e1', amount: 10, date: DateTime(2026, 5, 5)),
    ];
    await controller.loadExpenses();
    repository.nextError = 'Network error';

    final result = await controller.remove('e1');

    expect(result.failed, isTrue);
    expect(controller.expenses.length, 1);
    expect(controller.deletingId.value, isNull);
  });

  test('clear wipes cached data on logout', () async {
    repository.rows = [
      buildExpense(id: 'e1', amount: 10, date: DateTime(2026, 5, 5)),
    ];
    await controller.loadExpenses();

    controller.clear();

    expect(controller.expenses, isEmpty);
    expect(controller.loadingState.value, LoadingState.initial);
    expect(controller.errorMessage.value, isEmpty);
  });
}
