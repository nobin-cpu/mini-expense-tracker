import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';

class SetupRequiredView extends StatelessWidget {
  const SetupRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.space20),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings_suggest_rounded,
                    size: 34,
                    color: AppColors.warning,
                  ),
                ),
                AppDimens.gapH20,
                Text(
                  AppStrings.setupTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                AppDimens.gapH12,
                Text(
                  AppStrings.setupMessage,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppDimens.gapH20,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimens.space16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Text(
                    'dart pub global activate flutterfire_cli\n'
                    'flutterfire configure',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
