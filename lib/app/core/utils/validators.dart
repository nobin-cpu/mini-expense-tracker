import '../values/app_strings.dart';

class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(
    r'^[\w.!#$%&’*+/=?^`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$',
  );

  static String? required(String? value) {
    return (value == null || value.trim().isEmpty)
        ? AppStrings.requiredField
        : null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.requiredField;
    return _emailPattern.hasMatch(trimmed) ? null : AppStrings.invalidEmail;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.requiredField;
    return value.length < 6 ? AppStrings.shortPassword : null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return AppStrings.requiredField;
    return value == original ? null : AppStrings.passwordMismatch;
  }

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.requiredField;
    return trimmed.length < 2 ? AppStrings.nameTooShort : null;
  }

  static String? amount(String? value) {
    final typed = value?.trim() ?? '';
    if (typed.isEmpty) return AppStrings.requiredField;

    final number = parseAmount(typed);
    if (number == null || number <= 0) return AppStrings.invalidAmount;
    return null;
  }

  static double? parseAmount(String? value) {
    final withoutCommas = (value ?? '').replaceAll(',', '').trim();
    if (withoutCommas.isEmpty) return null;
    return double.tryParse(withoutCommas);
  }
}
