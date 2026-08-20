import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_expense_tracker/app/data/enums/app_enums.dart';
import 'package:mini_expense_tracker/app/data/models/app_user.dart';
import 'package:mini_expense_tracker/app/data/models/expense.dart';

void main() {
  group('Expense.fromMap', () {
    test('reads a Firestore document', () {
      final expense = Expense.fromMap('abc-123', 'user-1', {
        'amount': 42.75,
        'category': 'food',
        'date': Timestamp.fromDate(DateTime(2026, 8, 12)),
        'note': '  Lunch  ',
        'createdAt': Timestamp.fromDate(DateTime(2026, 8, 12, 10)),
      });

      expect(expense.id, 'abc-123');
      expect(expense.userId, 'user-1');
      expect(expense.amount, 42.75);
      expect(expense.category, ExpenseCategory.food);
      expect(expense.date, DateTime(2026, 8, 12));
      expect(expense.note, 'Lunch');
      expect(expense.hasNote, isTrue);
    });

    test('reads an amount that was stored as text', () {
      final expense = Expense.fromMap('1', 'u', {
        'amount': '9.99',
        'category': 'other',
        'date': Timestamp.fromDate(DateTime(2026, 1, 1)),
      });

      expect(expense.amount, 9.99);
    });

    test('falls back to "other" for an unknown category', () {
      final expense = Expense.fromMap('1', 'u', {
        'amount': 1,
        'category': 'crypto-jets',
        'date': Timestamp.fromDate(DateTime(2026, 1, 1)),
      });

      expect(expense.category, ExpenseCategory.other);
    });

    test('treats a blank note as no note', () {
      final expense = Expense.fromMap('1', 'u', {
        'amount': 1,
        'category': 'other',
        'date': Timestamp.fromDate(DateTime(2026, 1, 1)),
        'note': '   ',
      });

      expect(expense.note, isNull);
      expect(expense.hasNote, isFalse);
    });
  });

  group('Expense.toMap', () {
    test('saves the day at midnight so it cannot drift', () {
      final data = Expense(
        id: '1',
        userId: 'user-1',
        amount: 10,
        category: ExpenseCategory.transport,
        date: DateTime(2026, 3, 9, 23, 45),
        note: 'Bus',
      ).toMap();

      expect((data['date'] as Timestamp).toDate(), DateTime(2026, 3, 9));
      expect(data['category'], 'transport');
      expect(data['note'], 'Bus');
      expect(data.containsKey('id'), isFalse);
      expect(data.containsKey('userId'), isFalse);
    });

    test('saves null for an empty note', () {
      final data = Expense(
        id: '1',
        userId: 'u',
        amount: 10,
        category: ExpenseCategory.other,
        date: DateTime(2026, 1, 1),
        note: '   ',
      ).toMap();

      expect(data['note'], isNull);
    });

    test('leaves updatedAt out until the expense is edited', () {
      final expense = Expense(
        id: '1',
        userId: 'u',
        amount: 10,
        category: ExpenseCategory.other,
        date: DateTime(2026, 1, 1),
      );

      expect(expense.toMap().containsKey('updatedAt'), isFalse);
      expect(
        expense.copyWith(updatedAt: DateTime(2026, 2, 2)).toMap()['updatedAt'],
        Timestamp.fromDate(DateTime(2026, 2, 2)),
      );
    });
  });

  group('AppUser', () {
    test('falls back to the email local part when there is no name', () {
      const user = AppUser(id: '1', email: 'jane.doe@example.com');
      expect(user.displayName, 'jane.doe');
      expect(user.initials, 'J');
    });

    test('builds initials from the first and last name', () {
      const user = AppUser(id: '1', email: 'x@y.z', name: 'Jane Ann Doe');
      expect(user.displayName, 'Jane Ann Doe');
      expect(user.initials, 'JD');
    });

    test('reads a Firestore profile document', () {
      final user = AppUser.fromMap('uid-1', {
        'name': ' Jane Doe ',
        'email': 'jane@example.com',
        'createdAt': Timestamp.fromDate(DateTime(2026, 5, 1)),
      });

      expect(user.id, 'uid-1');
      expect(user.name, 'Jane Doe');
      expect(user.createdAt, DateTime(2026, 5, 1));
    });
  });
}
