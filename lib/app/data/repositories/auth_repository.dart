import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../models/result.dart';
import '../services/firebase_service.dart';

abstract class AuthRepository {
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<AppUser>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<AppUser?>> currentUser();

  AppUser? get signedInAccount;

  Stream<bool> get isSignedIn;
}

class FirebaseAuthRepository implements AuthRepository {
  CollectionReference<Map<String, dynamic>> get _users =>
      FirebaseService.db.collection('users');

  @override
  Stream<bool> get isSignedIn =>
      FirebaseService.auth.authStateChanges().map((account) => account != null);

  @override
  AppUser? get signedInAccount {
    final account = FirebaseService.account;
    return account == null ? null : _fromAccount(account);
  }

  @override
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseService.auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      final account = credential.user;
      if (account == null) {
        return const Result.fail('Could not create the account.');
      }

      final profile = AppUser(
        id: account.uid,
        email: account.email ?? email.trim(),
        name: name.trim(),
        createdAt: account.metadata.creationTime ?? DateTime.now(),
      );

      try {
        await account.updateDisplayName(profile.name);
        await _users.doc(profile.id).set(profile.toMap());
      } catch (e) {
        await _discardAccount(account);
        return Result.fail(FirebaseService.describeError(e));
      }

      return Result.ok(profile);
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  Future<void> _discardAccount(User account) async {
    try {
      await account.delete();
    } catch (_) {
      try {
        await FirebaseService.auth.signOut();
      } catch (_) {
      }
    }
  }

  @override
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseService.auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final account = credential.user;
      if (account == null) {
        return const Result.fail('Incorrect email or password.');
      }
      return Result.ok(await _loadProfile(account));
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await FirebaseService.auth.signOut();
      return const Result.ok(null);
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  @override
  Future<Result<AppUser?>> currentUser() async {
    final account = FirebaseService.account;
    if (account == null) return const Result.ok(null);
    try {
      return Result.ok(await _loadProfile(account));
    } catch (e) {
      return Result.fail(FirebaseService.describeError(e));
    }
  }

  Future<AppUser> _loadProfile(User account) async {
    final document = await _users.doc(account.uid).get();
    final data = document.data();

    if (data != null) {
      final profile = AppUser.fromMap(account.uid, data);
      return profile.email.isEmpty
          ? profile.copyWith(email: account.email ?? '')
          : profile;
    }

    final profile = _fromAccount(account);
    await _users.doc(profile.id).set(profile.toMap());
    return profile;
  }

  AppUser _fromAccount(User account) {
    return AppUser(
      id: account.uid,
      email: account.email ?? '',
      name: account.displayName?.trim() ?? '',
      createdAt: account.metadata.creationTime,
    );
  }
}
