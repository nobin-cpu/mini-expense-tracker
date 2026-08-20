import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../firebase_options.dart';
import '../../core/values/app_strings.dart';

class FirebaseService {
  const FirebaseService._();

  static const String _placeholderKey = 'REPLACE_ME';

  static bool _started = false;

  static bool get isStarted => _started;

  static Future<bool> start() async {
    if (_started) return true;
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      if (_isPlaceholder(options)) return false;
      await Firebase.initializeApp(options: options);
      _started = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;

  static FirebaseFirestore get db => FirebaseFirestore.instance;

  static User? get account => auth.currentUser;

  static String? get userId => account?.uid;

  static bool _isPlaceholder(FirebaseOptions options) {
    return options.apiKey.contains(_placeholderKey) ||
        options.projectId.contains(_placeholderKey);
  }

  static String describeError(Object error) {
    if (error is FirebaseAuthException) return _authMessage(error);
    if (error is FirebaseException) return _firestoreMessage(error);
    if (error is TimeoutException) return AppStrings.networkError;

    final text = error.toString();
    final looksOffline =
        text.contains('SocketException') ||
        text.contains('Failed host lookup') ||
        text.contains('ClientException') ||
        text.contains('XMLHttpRequest');
    return looksOffline ? AppStrings.networkError : AppStrings.genericError;
  }

  static String _authMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return AppStrings.invalidEmail;
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return AppStrings.shortPassword;
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      case 'network-request-failed':
        return AppStrings.networkError;
      case 'operation-not-allowed':
        return 'Email sign-in is turned off for this Firebase project.';
      default:
        return AppStrings.genericError;
    }
  }

  static String _firestoreMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'You do not have permission to do that.';
      case 'unavailable':
      case 'deadline-exceeded':
        return AppStrings.networkError;
      case 'not-found':
        return 'That expense no longer exists.';
      default:
        final message = error.message ?? '';
        return message.isEmpty ? AppStrings.genericError : message;
    }
  }
}
