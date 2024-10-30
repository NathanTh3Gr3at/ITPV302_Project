import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
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
  });

  factory AuthUser.fromFirebase(User user, Map<String, dynamic> userData) {
    return AuthUser(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
      createDate: (userData['createDate'] as Timestamp).toDate(),
      updateDate: (userData['updateDate'] as Timestamp).toDate(),
      role: userData['role'],
      userPreferences: Map<String, dynamic>.from(userData['userPreferences']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'createDate': createDate,
      'updateDate': updateDate,
      'role': role,
      'userPreferences': userPreferences,
    };
  }
}
