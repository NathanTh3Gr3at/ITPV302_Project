import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  String username;
  DateTime createDate;
  DateTime updateDate;
  String role;
  Map<String, dynamic> userPreferences;

  AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.createDate,
    required this.updateDate,
    required this.role,
    required this.userPreferences,
    required this.username,
  });

  factory AuthUser.fromFirebase(User user, Map<String, dynamic> userData) {
    return AuthUser(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
      createDate: (userData['createDate'] != null)
          ? (userData['createDate'] as Timestamp).toDate()
          : DateTime.now(),
      updateDate: (userData['updateDate'] != null)
          ? (userData['updateDate'] as Timestamp).toDate()
          : DateTime.now(),
      role: userData['role'] ?? 'user',
      userPreferences: userData['userPreferences'] != null
          ? Map<String, dynamic>.from(userData['userPreferences'])
          : {},
      username: userData['username'] ?? 'No username',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'isEmailVerified': isEmailVerified,
      'createDate': createDate,
      'updateDate': updateDate,
      'role': role,
      'userPreferences': userPreferences,
    };
  }
}
