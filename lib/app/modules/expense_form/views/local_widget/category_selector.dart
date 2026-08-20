import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../data/enums/app_enums.dart';
import '../../controllers/expense_form_controller.dart';

class CategorySelector extends GetView<ExpenseFormController> {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.category, style: theme.textTheme.titleSmall),
        AppDimens.gapH8,
        Obx(() {
          final selected = controller.selectedCategory.value;
          return Wrap(
            spacing: AppDimens.space8,
            runSpacing: AppDimens.space8,
            children: [
              for (final category in ExpenseCategory.values)
                _CategoryChoice(
                  category: category,
                  isSelected: selected == category,
                  onTap: () => controller.selectCategory(category),
                ),
            ],
          );
        }),
        Obx(() {
          if (controller.categoryError.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: AppDimens.space8),
            child: Text(
              controller.categoryError.value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _CategoryChoice extends StatelessWidget {
  const _CategoryChoice({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ExpenseCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        AppColors.categoryPalette[category.colorIndex %
            AppColors.categoryPalette.length];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.14)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? color : theme.dividerColor,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 16,
              color: isSelected ? color : theme.textTheme.bodySmall?.color,
            ),
            AppDimens.gapW8,
            Text(
              category.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
