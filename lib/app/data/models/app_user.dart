import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.name = '',
    this.createdAt,
  });

  final String id;
  final String email;
  final String name;
  final DateTime? createdAt;

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    return AppUser(
      id: id,
      email: (data['email'] as String?)?.trim() ?? '',
      name: (data['name'] as String?)?.trim() ?? '',
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.tryParse(createdAt?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
    };
  }

  String get displayName {
    if (name.isNotEmpty) return name;
    final beforeAt = email.split('@').first;
    return beforeAt.isEmpty ? 'User' : beforeAt;
  }

  String get initials {
    final words = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  AppUser copyWith({String? name, String? email}) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt,
    );
  }
}
