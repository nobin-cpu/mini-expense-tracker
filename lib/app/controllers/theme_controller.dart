import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  ThemeController(this._prefs);

  static const String _storageKey = 'is_dark_mode';

  final SharedPreferences _prefs;

  final RxBool isDarkMode = false.obs;

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _prefs.getBool(_storageKey) ?? false;
  }

  Future<void> toggleDarkMode(bool enabled) async {
    isDarkMode.value = enabled;
    Get.changeThemeMode(themeMode);
    await _prefs.setBool(_storageKey, enabled);
  }
}
