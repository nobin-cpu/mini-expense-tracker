import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/app_enums.dart';

class Expense {
  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasNote => note != null && note!.trim().isNotEmpty;

  factory Expense.fromMap(String id, String userId, Map<String, dynamic> data) {
    final note = (data['note'] as String?)?.trim() ?? '';
    return Expense(
      id: id,
      userId: userId,
      amount: _readAmount(data['amount']),
      category: ExpenseCategory.fromKey(data['category']?.toString()),
      date: _readDate(data['date']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      note: note.isEmpty ? null : note,
      createdAt: _readDate(data['createdAt']),
      updatedAt: _readDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category.key,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'note': hasNote ? note!.trim() : null,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? note,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static double _readAmount(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
