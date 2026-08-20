import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../values/app_dimens.dart';
import '../values/app_strings.dart';

class AppDialog {
  const AppDialog._();

  static Future<bool> confirm({
    required String title,
    required String message,
    String confirmText = AppStrings.delete,
    String cancelText = AppStrings.cancel,
    bool isDestructive = true,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title, style: Get.textTheme.titleLarge),
        content: Text(message, style: Get.textTheme.bodyMedium),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppDimens.space12,
          0,
          AppDimens.space12,
          AppDimens.space12,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: Text(cancelText),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(96, 44),
              backgroundColor: isDestructive
                  ? AppColors.danger
                  : Get.theme.colorScheme.primary,
            ),
            onPressed: () => Get.back<bool>(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: true,
    );
    return result ?? false;
  }
}
