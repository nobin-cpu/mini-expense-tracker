import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/expense_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/responsive_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();
    final expenseController = Get.find<ExpenseController>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: SafeArea(
        top: false,
        child: ResponsiveBody(
          child: ListView(
            padding: AppDimens.pagePadding,
            children: [
              Obx(() {
                final user = authController.user.value;
                return Container(
                  padding: const EdgeInsets.all(AppDimens.space20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          user?.initials ?? '?',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      AppDimens.gapH16,
                      Text(
                        user?.displayName ?? '',
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      AppDimens.gapH4,
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
              AppDimens.gapH24,
              Text(
                AppStrings.accountInformation,
                style: theme.textTheme.titleMedium,
              ),
              AppDimens.gapH12,
              Obx(() {
                final user = authController.user.value;
                return _InfoCard(
                  rows: [
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: AppStrings.name,
                      value: user?.name.isNotEmpty == true
                          ? user!.name
                          : user?.displayName ?? '—',
                    ),
                    _InfoRow(
                      icon: Icons.alternate_email_rounded,
                      label: AppStrings.email,
                      value: user?.email ?? '—',
                    ),
                    _InfoRow(
                      icon: Icons.event_available_rounded,
                      label: AppStrings.memberSince,
                      value: user?.createdAt == null
                          ? '—'
                          : Formatters.date(user!.createdAt!),
                    ),
                    _InfoRow(
                      icon: Icons.receipt_long_rounded,
                      label: AppStrings.expenses,
                      value:
                          '${expenseController.expenses.length} · '
                          '${Formatters.money(expenseController.total)}',
                    ),
                  ],
                );
              }),
              AppDimens.gapH24,
              Text(AppStrings.preferences, style: theme.textTheme.titleMedium),
              AppDimens.gapH12,
              Material(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Obx(
                    () => SwitchListTile.adaptive(
                      value: themeController.isDarkMode.value,
                      onChanged: themeController.toggleDarkMode,
                      title: const Text(AppStrings.darkMode),
                      secondary: Icon(
                        themeController.isDarkMode.value
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.space16,
                        vertical: AppDimens.space4,
                      ),
                    ),
                  ),
                ),
              ),
              AppDimens.gapH32,
              Obx(
                () => AppButton(
                  label: AppStrings.logout,
                  icon: Icons.logout_rounded,
                  isOutlined: true,
                  isLoading: authController.isLoggingOut.value,
                  onPressed: authController.confirmAndLogout,
                ),
              ),
              AppDimens.gapH24,
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: theme.dividerColor),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space16,
        vertical: AppDimens.space16,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.lightSubText),
          AppDimens.gapW12,
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          AppDimens.gapW8,
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
