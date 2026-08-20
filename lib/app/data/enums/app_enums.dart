import 'package:flutter/material.dart';

enum LoadingState { initial, loading, loaded, empty, error }

enum ExpenseCategory {
  food('food', 'Food & Drinks', Icons.restaurant_rounded, 0),
  transport('transport', 'Transport', Icons.directions_bus_rounded, 1),
  shopping('shopping', 'Shopping', Icons.shopping_bag_rounded, 2),
  bills('bills', 'Bills & Utilities', Icons.receipt_long_rounded, 3),
  health('health', 'Health', Icons.favorite_rounded, 4),
  entertainment('entertainment', 'Entertainment', Icons.movie_rounded, 5),
  education('education', 'Education', Icons.school_rounded, 6),
  other('other', 'Other', Icons.category_rounded, 7);

  const ExpenseCategory(this.key, this.label, this.icon, this.colorIndex);

  final String key;
  final String label;
  final IconData icon;

  final int colorIndex;

  static ExpenseCategory fromKey(String? key) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => ExpenseCategory.other,
    );
  }
}
