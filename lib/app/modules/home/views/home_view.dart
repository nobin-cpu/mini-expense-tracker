import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/enums/app_enums.dart';
import '../../../global_widgets/category_donut_chart.dart';
import '../../../global_widgets/expense_tile.dart';
import '../../../global_widgets/responsive_body.dart';
import '../../../global_widgets/section_header.dart';
import '../../../global_widgets/state_views.dart';
import '../controllers/home_controller.dart';
import 'local_widget/home_header.dart';
import 'local_widget/home_summary.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseController = controller.expenseController;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ResponsiveBody(
            child: Obx(() {
              final state = expenseController.loadingState.value;

              if (state == LoadingState.loading ||
                  state == LoadingState.initial) {
                return const _HomeSkeleton();
              }

              if (state == LoadingState.error) {
                return _ScrollableCenter(
                  child: ErrorView(
                    message: expenseController.errorMessage.value,
                    onRetry: controller.retry,
                  ),
                );
              }

              final recent = expenseController.recentExpenses;

              return ListView(
                padding: const EdgeInsets.only(
                  left: AppDimens.space16,
                  right: AppDimens.space16,
                  top: AppDimens.space16,
                  bottom: AppDimens.space32 * 2.5,
                ),
                children: [
                  const HomeHeader(),
                  AppDimens.gapH20,
                  HomeSummary(
                    total: expenseController.total,
                    monthTotal: expenseController.currentMonthTotal,
                    totalCount: expenseController.expenses.length,
                  ),
                  if (expenseController.categoryTotals.length > 1) ...[
                    AppDimens.gapH24,
                    const SectionHeader(title: AppStrings.spendingByCategory),
                    AppDimens.gapH12,
                    CategoryDonutChart(
                      totals: expenseController.categoryTotals,
                    ),
                  ],
                  AppDimens.gapH24,
                  SectionHeader(
                    title: AppStrings.recentExpenses,
                    actionLabel: recent.isEmpty ? null : AppStrings.seeAll,
                    onAction: recent.isEmpty ? null : controller.seeAllExpenses,
                  ),
                  AppDimens.gapH12,
                  if (recent.isEmpty)
                    EmptyView(
                      title: AppStrings.emptyExpensesTitle,
                      message: AppStrings.emptyExpensesMessage,
                      icon: Icons.receipt_long_rounded,
                      actionLabel: AppStrings.addExpense,
                      onAction: controller.addExpense,
                    )
                  else
                    for (final expense in recent)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: ExpenseTile(
                          expense: expense,
                          onTap: () => controller.editExpense(expense),
                        ),
                      ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ScrollableCenter extends StatelessWidget {
  const _ScrollableCenter({required this.child});

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

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppDimens.pagePadding,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Row(
          children: [
            SkeletonBox(height: 46, width: 46, radius: 46),
            AppDimens.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 16, width: 140),
                  AppDimens.gapH8,
                  SkeletonBox(height: 12, width: 90),
                ],
              ),
            ),
          ],
        ),
        AppDimens.gapH24,
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 104, radius: 14)),
            AppDimens.gapW12,
            Expanded(child: SkeletonBox(height: 104, radius: 14)),
          ],
        ),
        AppDimens.gapH24,
        SkeletonBox(height: 18, width: 160),
        AppDimens.gapH12,
        SkeletonBox(height: 72, radius: 14),
        AppDimens.gapH12,
        SkeletonBox(height: 72, radius: 14),
        AppDimens.gapH12,
        SkeletonBox(height: 72, radius: 14),
      ],
    );
  }
}
