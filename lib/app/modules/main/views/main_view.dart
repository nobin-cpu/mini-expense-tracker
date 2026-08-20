import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_strings.dart';
import '../../expense_list/views/expense_list_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [HomeView(), ExpenseListView(), ProfileView()],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.currentIndex.value == MainController.profileTab
            ? const SizedBox.shrink()
            : FloatingActionButton.extended(
                onPressed: controller.openExpenseForm,
                icon: const Icon(Icons.add_rounded),
                label: const Text(AppStrings.addExpense),
              ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: AppStrings.home,
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: AppStrings.expenses,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }
}
