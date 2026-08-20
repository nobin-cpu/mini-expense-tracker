import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../values/app_dimens.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void success(String message) =>
      _show(message, AppColors.success, Icons.check_circle_rounded);

  static void error(String message) =>
      _show(message, AppColors.danger, Icons.error_rounded);

  static void info(String message) =>
      _show(message, AppColors.primary, Icons.info_rounded);

  static void _show(String message, Color color, IconData icon) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            AppDimens.gapW12,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        margin: AppDimens.pagePadding,
        borderRadius: AppDimens.radiusSm,
        duration: const Duration(seconds: 3),
        isDismissible: true,
      ),
    );
  }
}
