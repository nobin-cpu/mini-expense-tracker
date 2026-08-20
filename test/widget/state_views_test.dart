import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_expense_tracker/app/core/theme/app_theme.dart';
import 'package:mini_expense_tracker/app/core/values/app_strings.dart';
import 'package:mini_expense_tracker/app/global_widgets/app_button.dart';
import 'package:mini_expense_tracker/app/global_widgets/state_views.dart';

Widget wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('EmptyView shows its copy and optional action', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(
        EmptyView(
          title: AppStrings.emptyExpensesTitle,
          message: AppStrings.emptyExpensesMessage,
          actionLabel: AppStrings.addExpense,
          onAction: () => tapped++,
        ),
      ),
    );

    expect(find.text(AppStrings.emptyExpensesTitle), findsOneWidget);
    expect(find.text(AppStrings.emptyExpensesMessage), findsOneWidget);

    await tester.tap(find.text(AppStrings.addExpense));
    await tester.pumpAndSettle();
    expect(tapped, 1);
  });

  testWidgets('EmptyView hides the action when none is given', (tester) async {
    await tester.pumpWidget(
      wrap(
        const EmptyView(
          title: AppStrings.emptyFilteredTitle,
          message: AppStrings.emptyFilteredMessage,
        ),
      ),
    );

    expect(find.byType(AppButton), findsNothing);
  });

  testWidgets('ErrorView shows the message and retries', (tester) async {
    var retried = 0;
    await tester.pumpWidget(
      wrap(ErrorView(message: 'Server exploded', onRetry: () => retried++)),
    );

    expect(find.text(AppStrings.errorTitle), findsOneWidget);
    expect(find.text('Server exploded'), findsOneWidget);

    await tester.tap(find.text(AppStrings.tryAgain));
    await tester.pumpAndSettle();
    expect(retried, 1);
  });

  testWidgets('ErrorView falls back to the generic message', (tester) async {
    await tester.pumpWidget(wrap(const ErrorView()));

    expect(find.text(AppStrings.genericError), findsOneWidget);
    expect(find.text(AppStrings.tryAgain), findsNothing);
  });

  testWidgets('AppButton disables itself and shows a spinner while loading', (
    tester,
  ) async {
    var pressed = 0;
    await tester.pumpWidget(
      wrap(
        AppButton(
          label: AppStrings.save,
          isLoading: true,
          onPressed: () => pressed++,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(pressed, 0);
  });
}
