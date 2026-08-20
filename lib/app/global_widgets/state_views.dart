import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/values/app_dimens.dart';
import '../core/values/app_strings.dart';
import 'app_button.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.space20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
              ),
              child: Icon(icon, size: 34, color: theme.colorScheme.primary),
            ),
            AppDimens.gapH20,
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            AppDimens.gapH8,
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            if (actionLabel != null && onAction != null) ...[
              AppDimens.gapH20,
              SizedBox(
                width: 220,
                child: AppButton(
                  label: actionLabel!,
                  icon: Icons.add_rounded,
                  onPressed: onAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.space20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.danger.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.wifi_tethering_error_rounded,
                size: 34,
                color: AppColors.danger,
              ),
            ),
            AppDimens.gapH20,
            Text(AppStrings.errorTitle, style: theme.textTheme.titleLarge),
            AppDimens.gapH8,
            Text(
              message?.isNotEmpty == true ? message! : AppStrings.genericError,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            if (onRetry != null) ...[
              AppDimens.gapH20,
              SizedBox(
                width: 200,
                child: AppButton(
                  label: AppStrings.tryAgain,
                  icon: Icons.refresh_rounded,
                  isOutlined: true,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.radius = AppDimens.radiusSm,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class ExpenseListSkeleton extends StatelessWidget {
  const ExpenseListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppDimens.pagePadding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => AppDimens.gapH12,
      itemBuilder: (_, _) => Container(
        padding: AppDimens.cardPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            const SkeletonBox(height: 44, width: 44, radius: 12),
            AppDimens.gapW12,
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 14, width: 120),
                  AppDimens.gapH8,
                  SkeletonBox(height: 12, width: 80),
                ],
              ),
            ),
            const SkeletonBox(height: 16, width: 64),
          ],
        ),
      ),
    );
  }
}
