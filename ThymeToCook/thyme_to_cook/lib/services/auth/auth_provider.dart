import 'package:thyme_to_cook/services/auth/auth_user.dart';

abstract class AuthProvider{
  Future<void>initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUserDoc({
    required String email,
    required String username,
    required Map<String, dynamic> userPreferences,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void>sendPasswordReset({required String toEmail});

  Future<AuthUser> registerUser({
    required String email,
    required String password,
  });

  Future<void> refreshUser();

}