import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/app_text_field.dart';
import '../../../global_widgets/responsive_body.dart';
import '../controllers/expense_form_controller.dart';
import 'local_widget/category_selector.dart';
import 'local_widget/date_picker_field.dart';

class ExpenseFormView extends GetView<ExpenseFormController> {
  const ExpenseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        actions: [
          if (controller.isEditMode)
            Obx(
              () => controller.isDeleting.value
                  ? const Padding(
                      padding: EdgeInsets.only(right: AppDimens.space20),
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      tooltip: AppStrings.delete,
                      onPressed: controller.deleteExpense,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.danger,
                      ),
                    ),
            ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.space16,
                    AppDimens.space8,
                    AppDimens.space16,
                    AppDimens.space24,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          label: AppStrings.amount,
                          hint: '0.00',
                          controller: controller.amountController,
                          validator: Validators.amount,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          prefixIcon: Icons.attach_money_rounded,
                        ),
                        AppDimens.gapH20,
                        const CategorySelector(),
                        AppDimens.gapH20,
                        const DatePickerField(),
                        AppDimens.gapH20,
                        AppTextField(
                          label: AppStrings.noteOptional,
                          hint: AppStrings.noteHint,
                          controller: controller.noteController,
                          maxLines: 3,
                          maxLength: 140,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const _SubmitBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitBar extends GetView<ExpenseFormController> {
  const _SubmitBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space12,
        AppDimens.space16,
        AppDimens.space16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          Obx(() {
            final category = controller.selectedCategory.value;
            return Row(
              children: [
                Expanded(
                  child: Text(
                    category?.label ?? AppStrings.filterCategory,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  Formatters.date(controller.selectedDate.value),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            );
          }),
          AppDimens.gapH12,
          Obx(
            () => AppButton(
              label: controller.submitLabel,
              icon: Icons.check_rounded,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.submit,
            ),
          ),
        ],
      ),
    );
  }
}
