import 'package:flutter/material.dart';

import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            AppDimens.gapW12,
            Expanded(
              child: Text(
                AppStrings.appName,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        AppDimens.gapH32,
        Text(title, style: theme.textTheme.headlineMedium),
        AppDimens.gapH8,
        Text(subtitle, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
