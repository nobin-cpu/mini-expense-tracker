import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/expense_controller.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/enums/app_enums.dart';
import '../../../data/models/expense.dart';

class ExpenseFormController extends GetxController {
  final ExpenseController _expenseController = Get.find<ExpenseController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final Rx<ExpenseCategory?> selectedCategory = Rx<ExpenseCategory?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isDeleting = false.obs;

  final RxString categoryError = ''.obs;

  Expense? _editing;

  bool get isEditMode => _editing != null;

  String get title =>
      isEditMode ? AppStrings.editExpense : AppStrings.addExpense;

  String get submitLabel =>
      isEditMode ? AppStrings.saveChanges : AppStrings.save;

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments;
    if (argument is Expense) {
      _editing = argument;
      amountController.text = argument.amount.toStringAsFixed(2);
      noteController.text = argument.note ?? '';
      selectedCategory.value = argument.category;
      selectedDate.value = argument.date;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  void selectCategory(ExpenseCategory category) {
    selectedCategory.value = category;
    categoryError.value = '';
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value.isAfter(now) ? now : selectedDate.value,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year, now.month, now.day),
      helpText: AppStrings.date,
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> submit() async {
    final isFormValid = formKey.currentState?.validate() ?? false;
    final category = selectedCategory.value;
    categoryError.value = category == null ? AppStrings.requiredField : '';

    if (!isFormValid || category == null) return;
    if (isSubmitting.value) return;

    FocusManager.instance.primaryFocus?.unfocus();
    isSubmitting.value = true;

    final amount = Validators.parseAmount(amountController.text) ?? 0;
    final note = noteController.text.trim();
    final editing = _editing;

    final result = editing == null
        ? await _expenseController.create(
            amount: amount,
            category: category,
            date: selectedDate.value,
            note: note.isEmpty ? null : note,
          )
        : await _expenseController.edit(
            Expense(
              id: editing.id,
              userId: editing.userId,
              amount: amount,
              category: category,
              date: selectedDate.value,
              note: note.isEmpty ? null : note,
              createdAt: editing.createdAt,
            ),
          );

    isSubmitting.value = false;

    if (result.failed) {
      AppSnackbar.error(result.error ?? AppStrings.genericError);
      return;
    }

    Get.back();
    AppSnackbar.success(
      isEditMode ? AppStrings.expenseUpdated : AppStrings.expenseAdded,
    );
  }

  Future<void> deleteExpense() async {
    final editing = _editing;
    if (editing == null) return;

    final confirmed = await AppDialog.confirm(
      title: AppStrings.deleteExpense,
      message: AppStrings.deleteExpenseMessage,
    );
    if (!confirmed) return;

    isDeleting.value = true;
    final result = await _expenseController.remove(editing.id);
    isDeleting.value = false;

    if (result.failed) {
      AppSnackbar.error(result.error ?? AppStrings.genericError);
      return;
    }

    Get.back();
    AppSnackbar.success(AppStrings.expenseDeleted);
  }
}
