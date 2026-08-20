import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/enums/app_enums.dart';
import '../../../global_widgets/expense_tile.dart';
import '../../../global_widgets/responsive_body.dart';
import '../../../global_widgets/state_views.dart';
import '../controllers/expense_list_controller.dart';
import '../local_widget/expense_filter_bar.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expenses),
        actions: [
          IconButton(
            tooltip: AppStrings.tryAgain,
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveBody(
          child: Column(
            children: [
              AppDimens.gapH4,
              const ExpenseFilterBar(),
              AppDimens.gapH12,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshData,
                  child: Obx(() => _buildBody(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = controller.expenseController.loadingState.value;

    if (state == LoadingState.loading || state == LoadingState.initial) {
      return const ExpenseListSkeleton();
    }

    if (state == LoadingState.error) {
      return _Scrollable(
        child: ErrorView(
          message: controller.expenseController.errorMessage.value,
          onRetry: controller.retry,
        ),
      );
    }

    if (!controller.expenseController.hasExpenses) {
      return _Scrollable(
        child: EmptyView(
          title: AppStrings.emptyExpensesTitle,
          message: AppStrings.emptyExpensesMessage,
          icon: Icons.receipt_long_rounded,
          actionLabel: AppStrings.addExpense,
          onAction: controller.addExpense,
        ),
      );
    }

    final expenses = controller.filteredExpenses;

    if (expenses.isEmpty) {
      return _Scrollable(
        child: EmptyView(
          title: AppStrings.emptyFilteredTitle,
          message: AppStrings.emptyFilteredMessage,
          icon: Icons.filter_alt_off_rounded,
        ),
      );
    }

    final theme = Theme.of(context);
    final deletingId = controller.expenseController.deletingId.value;

    return ListView.separated(
      padding: const EdgeInsets.only(
        left: AppDimens.space16,
        right: AppDimens.space16,
        top: AppDimens.space4,
        bottom: AppDimens.space32 * 2.5,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: expenses.length + 1,
      separatorBuilder: (_, _) => AppDimens.gapH12,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.space4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${expenses.length} '
                    '${expenses.length == 1 ? 'expense' : 'expenses'}',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                Text(
                  Formatters.money(controller.filteredTotal),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        final expense = expenses[index - 1];
        return ExpenseTile(
          expense: expense,
          onTap: () => controller.editExpense(expense),
          onDelete: () => controller.deleteExpense(expense),
          isDeleting: deletingId == expense.id,
        );
      },
    );
  }
}

class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );
  }
}
