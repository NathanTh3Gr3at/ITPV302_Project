import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
 // final String role;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    //required this.role,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid,
       // role:user.
      );
}
