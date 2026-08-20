import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/app_enums.dart';
import '../models/expense.dart';
import '../models/result.dart';
import '../services/firebase_service.dart';

abstract class ExpenseRepository {
  Future<Result<List<Expense>>> fetchExpenses();

  Future<Result<Expense>> createExpense({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  });

  Future<Result<Expense>> updateExpense(Expense expense);

  Future<Result<void>> deleteExpense(String id);
}

class FirebaseExpenseRepository implements ExpenseRepository {
  static const String _notSignedIn = 'You are not signed in.';

  CollectionReference<Map<String, dynamic>> _expensesOf(String userId) {
    return FirebaseService.db
        .collection('users')
        .doc(userId)
        .collection('expenses');
  }

  @override
  Future<Result<List<Expense>>> fetchExpenses() async {
    final userId = FirebaseService.userId;
    if (userId == null) return const Result.fail(_notSignedIn);

    try {
      final snapshot = await _expensesOf(
        userId,
      ).orderBy('date', descending: true).get();

      final expenses = snapshot.docs
          .map((doc) => Expense.fromMap(doc.id, userId, doc.data()))
          .toList();
      return Result.ok(expenses);
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  @override
  Future<Result<Expense>> createExpense({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  }) async {
    final userId = FirebaseService.userId;
    if (userId == null) return const Result.fail(_notSignedIn);

    try {
      final draft = Expense(
        id: '',
        userId: userId,
        amount: amount,
        category: category,
        date: date,
        note: note,
        createdAt: DateTime.now(),
      );

      final document = await _expensesOf(userId).add(draft.toMap());
      return Result.ok(draft.copyWith(id: document.id));
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  @override
  Future<Result<Expense>> updateExpense(Expense expense) async {
    final userId = FirebaseService.userId;
    if (userId == null) return const Result.fail(_notSignedIn);

    try {
      final updated = expense.copyWith(updatedAt: DateTime.now());
      await _expensesOf(userId).doc(updated.id).update(updated.toMap());
      return Result.ok(updated);
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  @override
  Future<Result<void>> deleteExpense(String id) async {
    final userId = FirebaseService.userId;
    if (userId == null) return const Result.fail(_notSignedIn);

    try {
      await _expensesOf(userId).doc(id).delete();
      return const Result.ok(null);
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }
}
