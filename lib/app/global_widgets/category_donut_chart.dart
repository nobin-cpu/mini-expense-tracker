import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../core/values/app_dimens.dart';
import '../data/models/category_total.dart';

class CategoryDonutChart extends StatelessWidget {
  const CategoryDonutChart({
    super.key,
    required this.totals,
    this.maxSlices = 5,
  });

  final List<CategoryTotal> totals;
  final int maxSlices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slices = _buildSlices();
    final grandTotal = slices.fold<double>(0, (sum, s) => sum + s.amount);
    if (grandTotal <= 0) return const SizedBox.shrink();

    return Container(
      padding: AppDimens.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 132,
            width: 132,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                    sections: [
                      for (final slice in slices)
                        PieChartSectionData(
                          value: slice.amount,
                          color: slice.color,
                          radius: 22,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total', style: theme.textTheme.labelSmall),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Formatters.moneyCompact(grandTotal),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDimens.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final slice in slices)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.space8),
                    child: _LegendRow(
                      color: slice.color,
                      label: slice.label,
                      percent: slice.amount / grandTotal,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_Slice> _buildSlices() {
    if (totals.isEmpty) return const [];

    final biggest = totals.take(maxSlices);
    final rest = totals.skip(maxSlices);

    final slices = [
      for (final total in biggest)
        _Slice(
          label: total.category.label,
          amount: total.amount,
          color:
              AppColors.categoryPalette[total.category.colorIndex %
                  AppColors.categoryPalette.length],
        ),
    ];

    if (rest.isNotEmpty) {
      slices.add(
        _Slice(
          label: 'Other categories',
          amount: rest.fold<double>(0, (sum, total) => sum + total.amount),
          color: AppColors.lightSubText,
        ),
      );
    }
    return slices;
  }
}

class _Slice {
  const _Slice({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.percent,
  });

  final Color color;
  final String label;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppDimens.gapW8,
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppDimens.gapW4,
        Text('${(percent * 100).round()}%', style: theme.textTheme.titleSmall),
      ],
    );
  }
}
