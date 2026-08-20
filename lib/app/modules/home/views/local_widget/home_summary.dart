import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../global_widgets/summary_card.dart';

class HomeSummary extends StatelessWidget {
  const HomeSummary({
    super.key,
    required this.total,
    required this.monthTotal,
    required this.totalCount,
  });

  final double total;
  final double monthTotal;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final totalCard = SummaryCard(
      label: AppStrings.totalSpent,
      value: Formatters.moneyCompact(total),
      caption: '$totalCount ${totalCount == 1 ? 'expense' : 'expenses'}',
      icon: Icons.savings_rounded,
      color: AppColors.primary,
    );
    final monthCard = SummaryCard(
      label: AppStrings.thisMonth,
      value: Formatters.moneyCompact(monthTotal),
      caption: Formatters.monthName(DateTime.now()),
      icon: Icons.calendar_month_rounded,
      color: AppColors.accent,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 340) {
          return Column(children: [totalCard, AppDimens.gapH12, monthCard]);
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: totalCard),
              AppDimens.gapW12,
              Expanded(child: monthCard),
            ],
          ),
        );
      },
    );
  }
}
