import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../core/values/app_dimens.dart';
import '../data/models/expense.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
    this.isDeleting = false,
  });

  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        AppColors.categoryPalette[expense.category.colorIndex %
            AppColors.categoryPalette.length];

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Container(
          padding: AppDimens.cardPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(expense.category.icon, color: color, size: 22),
              ),
              AppDimens.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.category.label,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppDimens.gapH4,
                    Text(
                      expense.hasNote
                          ? '${Formatters.relativeDay(expense.date)} · ${expense.note}'
                          : Formatters.relativeDay(expense.date),
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppDimens.gapW8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Formatters.money(expense.amount),
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                  ),
                  if (onDelete != null)
                    isDeleting
                        ? const Padding(
                            padding: EdgeInsets.only(top: AppDimens.space8),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.danger,
                              ),
                            ),
                          )
                        : _DeleteButton(onDelete: onDelete!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: TextButton.icon(
        onPressed: onDelete,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.space4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: AppColors.danger,
        ),
        icon: const Icon(Icons.delete_outline_rounded, size: 16),
        label: Text(
          'Delete',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.danger),
        ),
      ),
    );
  }
}
