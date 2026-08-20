import 'dart:async';

import 'package:get/get.dart';

import '../core/utils/app_dialog.dart';
import '../core/utils/app_snackbar.dart';
import '../core/values/app_strings.dart';
import '../data/models/app_user.dart';
import '../data/repositories/auth_repository.dart';
import '../routes/app_routes.dart';
import 'expense_controller.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  final Rx<AppUser?> user = Rx<AppUser?>(null);
  final RxBool isLoggingOut = false.obs;

  StreamSubscription<bool>? _watchSignedIn;

  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    _watchSignedIn = _repo.isSignedIn.listen((signedIn) {
      if (!signedIn) _onSignedOut();
    });
  }

  @override
  void onClose() {
    _watchSignedIn?.cancel();
    super.onClose();
  }

  Future<String> resolveStartRoute() async {
    final account = _repo.signedInAccount;
    if (account == null) return Routes.login;

    final result = await _repo.currentUser();
    if (result.success && result.data != null) {
      user.value = result.data;
      return Routes.main;
    }

    user.value = account;
    return Routes.main;
  }

  void setUser(AppUser value) => user.value = value;

  Future<void> confirmAndLogout() async {
    final confirmed = await AppDialog.confirm(
      title: AppStrings.logoutConfirmTitle,
      message: AppStrings.logoutConfirmMessage,
      confirmText: AppStrings.logout,
    );
    if (!confirmed) return;

    isLoggingOut.value = true;
    final result = await _repo.logout();
    isLoggingOut.value = false;

    if (result.failed) {
      AppSnackbar.error(result.error ?? AppStrings.genericError);
      return;
    }
    _onSignedOut();
  }

  void _onSignedOut() {
    final onAuthScreen =
        Get.currentRoute == Routes.login || Get.currentRoute == Routes.register;
    if (user.value == null && onAuthScreen) return;

    user.value = null;
    if (Get.isRegistered<ExpenseController>()) {
      Get.find<ExpenseController>().clear();
    }
    Get.offAllNamed(Routes.login);
  }
}
