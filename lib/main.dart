import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/values/app_strings.dart';
import 'app/data/services/firebase_service.dart';
import 'app/modules/splash/views/setup_required_view.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await FirebaseService.start();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    firebaseReady ? MiniExpenseApp(prefs: prefs) : const SetupRequiredApp(),
  );
}

class MiniExpenseApp extends StatelessWidget {
  const MiniExpenseApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = prefs.getBool('is_dark_mode') ?? false;

    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialBinding: InitialBinding(prefs),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}

class SetupRequiredApp extends StatelessWidget {
  const SetupRequiredApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SetupRequiredView(),
    );
  }
}
