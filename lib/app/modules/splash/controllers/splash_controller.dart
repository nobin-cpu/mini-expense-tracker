import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onReady() {
    super.onReady();
    _openFirstScreen();
  }

  Future<void> _openFirstScreen() async {
    final route = await _authController.resolveStartRoute();
    await Future<void>.delayed(const Duration(milliseconds: 350));
    Get.offAllNamed(route);
  }
}
