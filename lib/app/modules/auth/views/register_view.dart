import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/values/app_dimens.dart';
import '../../../core/values/app_strings.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/app_text_field.dart';
import '../../../global_widgets/responsive_body.dart';
import '../controllers/register_controller.dart';
import 'local_widget/auth_header.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space20,
              vertical: AppDimens.space16,
            ),
            child: Form(
              key: controller.formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: AppStrings.register,
                      subtitle: AppStrings.registerSubtitle,
                    ),
                    AppDimens.gapH32,
                    AppTextField(
                      label: AppStrings.fullName,
                      hint: 'Jane Doe',
                      controller: controller.nameController,
                      validator: Validators.name,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline_rounded,
                      autofillHints: const [AutofillHints.name],
                      maxLength: 60,
                    ),
                    AppDimens.gapH16,
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
                      hint: 'At least 6 characters',
                      controller: controller.passwordController,
                      validator: Validators.password,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.lock_outline_rounded,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    AppDimens.gapH16,
                    AppTextField(
                      label: AppStrings.confirmPassword,
                      hint: 'Repeat your password',
                      controller: controller.confirmPasswordController,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        controller.passwordController.text,
                      ),
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      onSubmitted: (_) => controller.submit(),
                    ),
                    AppDimens.gapH24,
                    Obx(
                      () => AppButton(
                        label: AppStrings.register,
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.submit,
                      ),
                    ),
                    AppDimens.gapH20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.haveAccount,
                          style: theme.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: controller.goToLogin,
                          child: const Text(AppStrings.signIn),
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
