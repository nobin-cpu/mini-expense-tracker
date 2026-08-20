import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (isSubmitting.value) return;

    FocusManager.instance.primaryFocus?.unfocus();
    isSubmitting.value = true;

    final result = await _repo.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    isSubmitting.value = false;

    final newUser = result.data;
    if (result.failed || newUser == null) {
      AppSnackbar.error(result.error ?? AppStrings.genericError);
      return;
    }

    _authController.setUser(newUser);
    Get.offAllNamed(Routes.main);
  }

  void goToLogin() => Get.back();
}
