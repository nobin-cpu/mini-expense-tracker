import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static const String currencySymbol = '\$';

  static final NumberFormat _money = NumberFormat.currency(
    symbol: currencySymbol,
    decimalDigits: 2,
  );
  static final NumberFormat _compactMoney = NumberFormat.compactCurrency(
    symbol: currencySymbol,
    decimalDigits: 1,
  );
  static final DateFormat _fullDate = DateFormat('d MMM yyyy');
  static final DateFormat _shortDate = DateFormat('d MMM');
  static final DateFormat _monthName = DateFormat('MMMM yyyy');

  static String money(double value) => _money.format(value);

  static String moneyCompact(double value) {
    if (value.abs() >= 100000) return _compactMoney.format(value);
    return _money.format(value);
  }

  static String date(DateTime value) => _fullDate.format(value);

  static String shortDate(DateTime value) => _shortDate.format(value);

  static String monthName(DateTime value) => _monthName.format(value);

  static String relativeDay(DateTime value) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(value.year, value.month, value.day);
    final daysAgo = today.difference(day).inDays;

    if (daysAgo == 0) return 'Today';
    if (daysAgo == 1) return 'Yesterday';
    if (day.year == today.year) return _shortDate.format(day);
    return _fullDate.format(day);
  }
}
