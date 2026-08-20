import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../../controllers/expense_form_controller.dart';

class DatePickerField extends GetView<ExpenseFormController> {
  const DatePickerField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.date, style: theme.textTheme.titleSmall),
        AppDimens.gapH8,
        InkWell(
          onTap: () => controller.pickDate(context),
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16,
              vertical: AppDimens.space16,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: theme.textTheme.bodySmall?.color,
                ),
                AppDimens.gapW12,
                Expanded(
                  child: Obx(
                    () => Text(
                      Formatters.date(controller.selectedDate.value),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
