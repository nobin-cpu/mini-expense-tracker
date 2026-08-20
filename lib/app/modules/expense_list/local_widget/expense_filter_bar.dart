import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/expense_list_controller.dart';

class ExpenseFilterBar extends GetView<ExpenseListController> {
  const ExpenseFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: controller.clearSearch,
                      ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space16,
                vertical: AppDimens.space12,
              ),
            ),
          ),
        ),
        AppDimens.gapH12,
        Obx(() {
          final categories = controller.expenseController.usedCategories;
          if (categories.isEmpty) return const SizedBox.shrink();
          final selected = controller.selectedCategory.value;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
            child: Row(
              children: [
                _CategoryChip(
                  label: AppStrings.allCategories,
                  isSelected: selected == null,
                  onSelected: () => controller.selectCategory(null),
                ),
                for (final category in categories) ...[
                  AppDimens.gapW8,
                  _CategoryChip(
                    label: category.label,
                    icon: category.icon,
                    color:
                        AppColors.categoryPalette[category.colorIndex %
                            AppColors.categoryPalette.length],
                    isSelected: selected == category,
                    onSelected: () => controller.selectCategory(
                      selected == category ? null : category,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      avatar: icon == null
          ? null
          : Icon(icon, size: 16, color: isSelected ? accent : null),
      label: Text(label),
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: isSelected ? accent : null,
      ),
      selectedColor: accent.withValues(alpha: 0.12),
      side: BorderSide(color: isSelected ? accent : theme.dividerColor),
    );
  }
}
