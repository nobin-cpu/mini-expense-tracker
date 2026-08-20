import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_expense_tracker/app/core/theme/app_theme.dart';
import 'package:mini_expense_tracker/app/data/enums/app_enums.dart';
import 'package:mini_expense_tracker/app/data/models/expense.dart';
import 'package:mini_expense_tracker/app/global_widgets/expense_tile.dart';

Widget wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  final expense = Expense(
    id: 'e1',
    userId: 'u1',
    amount: 42.5,
    category: ExpenseCategory.food,
    date: DateTime(2026, 8, 12),
    note: 'Lunch with the team',
    createdAt: DateTime(2026, 8, 12),
  );

  testWidgets('shows category, amount and note', (tester) async {
    await tester.pumpWidget(wrap(ExpenseTile(expense: expense)));

    expect(find.text(ExpenseCategory.food.label), findsOneWidget);
    expect(find.text('\$42.50'), findsOneWidget);
    expect(find.textContaining('Lunch with the team'), findsOneWidget);
    expect(find.byIcon(ExpenseCategory.food.icon), findsOneWidget);
  });

  testWidgets('hides the delete action unless onDelete is given', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(ExpenseTile(expense: expense)));
    expect(find.text('Delete'), findsNothing);

    await tester.pumpWidget(
      wrap(ExpenseTile(expense: expense, onDelete: () {})),
    );
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('calls onTap when the row is tapped', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(ExpenseTile(expense: expense, onTap: () => tapped++)),
    );

    await tester.tap(find.byType(ExpenseTile));
    await tester.pumpAndSettle();

    expect(tapped, 1);
  });

  testWidgets('calls onDelete when the delete action is tapped', (
    tester,
  ) async {
    var deleted = 0;
    await tester.pumpWidget(
      wrap(ExpenseTile(expense: expense, onDelete: () => deleted++)),
    );

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleted, 1);
  });

  testWidgets('swaps the delete action for a spinner while deleting', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(ExpenseTile(expense: expense, onDelete: () {}, isDeleting: true)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Delete'), findsNothing);
  });

  testWidgets('renders without a note and does not overflow', (tester) async {
    final noNote = Expense(
      id: 'e2',
      userId: 'u1',
      amount: 9.99,
      category: ExpenseCategory.transport,
      date: DateTime(2026, 8, 12),
    );

    await tester.pumpWidget(wrap(ExpenseTile(expense: noNote)));

    expect(find.text('\$9.99'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
