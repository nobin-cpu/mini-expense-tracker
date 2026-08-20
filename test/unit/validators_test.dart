import 'package:flutter_test/flutter_test.dart';
import 'package:mini_expense_tracker/app/core/utils/validators.dart';
import 'package:mini_expense_tracker/app/core/values/app_strings.dart';

void main() {
  group('Validators.email', () {
    test('accepts a well formed address', () {
      expect(Validators.email('jane.doe@example.com'), isNull);
    });

    test('rejects an empty value', () {
      expect(Validators.email('  '), AppStrings.requiredField);
    });

    test('rejects a malformed address', () {
      expect(Validators.email('jane@'), AppStrings.invalidEmail);
      expect(Validators.email('jane.example.com'), AppStrings.invalidEmail);
    });
  });

  group('Validators.password', () {
    test('accepts six characters or more', () {
      expect(Validators.password('secret'), isNull);
    });

    test('rejects a short password', () {
      expect(Validators.password('12345'), AppStrings.shortPassword);
    });

    test('rejects an empty password', () {
      expect(Validators.password(''), AppStrings.requiredField);
    });
  });

  group('Validators.confirmPassword', () {
    test('accepts a matching value', () {
      expect(Validators.confirmPassword('secret', 'secret'), isNull);
    });

    test('rejects a mismatch', () {
      expect(
        Validators.confirmPassword('secret1', 'secret2'),
        AppStrings.passwordMismatch,
      );
    });
  });

  group('Validators.amount', () {
    test('accepts decimals and thousands separators', () {
      expect(Validators.amount('12.50'), isNull);
      expect(Validators.amount('1,250.99'), isNull);
    });

    test('rejects zero, negatives and junk', () {
      expect(Validators.amount('0'), AppStrings.invalidAmount);
      expect(Validators.amount('-5'), AppStrings.invalidAmount);
      expect(Validators.amount('abc'), AppStrings.invalidAmount);
    });

    test('rejects an empty value', () {
      expect(Validators.amount(''), AppStrings.requiredField);
    });
  });

  group('Validators.parseAmount', () {
    test('strips commas', () {
      expect(Validators.parseAmount('1,234.56'), 1234.56);
    });

    test('returns null for junk', () {
      expect(Validators.parseAmount('12.3.4'), isNull);
      expect(Validators.parseAmount(''), isNull);
    });
  });

  group('Validators.name', () {
    test('needs at least two characters', () {
      expect(Validators.name('Jo'), isNull);
      expect(Validators.name('J'), AppStrings.nameTooShort);
      expect(Validators.name(' '), AppStrings.requiredField);
    });
  });
}
