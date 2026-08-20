import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../controllers/auth_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.user.value;
      return Row(
        children: [
          Container(
            height: 46,
            width: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              user?.initials ?? '?',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          AppDimens.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${user?.displayName ?? ''}',
                  style: theme.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppDimens.gapH4,
                Text(
                  Formatters.date(DateTime.now()),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
