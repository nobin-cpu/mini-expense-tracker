import 'package:get/get.dart';

import '../modules/auth/bindings/auth_bindings.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/expense_form/bindings/expense_form_binding.dart';
import '../modules/expense_form/views/expense_form_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static const String initial = Routes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(
        () => Get.put<SplashController>(SplashController()),
      ),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.expenseForm,
      page: () => const ExpenseFormView(),
      binding: ExpenseFormBinding(),
    ),
  ];
}
