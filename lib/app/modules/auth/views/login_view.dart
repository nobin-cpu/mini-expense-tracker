import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/app_text_field.dart';
import '../../../global_widgets/responsive_body.dart';
import '../controllers/login_controller.dart';
import 'local_widget/auth_header.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space20,
              vertical: AppDimens.space24,
            ),
            child: Form(
              key: controller.formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: AppStrings.welcomeBack,
                      subtitle: AppStrings.loginSubtitle,
                    ),
                    AppDimens.gapH32,
                    AppTextField(
                      label: AppStrings.email,
                      hint: 'you@example.com',
                      controller: controller.emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.alternate_email_rounded,
                      autofillHints: const [AutofillHints.email],
                    ),
                    AppDimens.gapH16,
                    AppTextField(
                      label: AppStrings.password,
                      hint: '••••••••',
                      controller: controller.passwordController,
                      validator: Validators.password,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => controller.submit(),
                    ),
                    AppDimens.gapH24,
                    Obx(
                      () => AppButton(
                        label: AppStrings.login,
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.submit,
                      ),
                    ),
                    AppDimens.gapH20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.noAccount,
                          style: theme.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: controller.goToRegister,
                          child: const Text(AppStrings.signUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
