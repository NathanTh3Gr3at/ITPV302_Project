import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:thyme_to_cook/firebase_options.dart';
import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
import 'package:thyme_to_cook/services/auth/auth_provider.dart';
import 'package:thyme_to_cook/services/auth/auth_user.dart';
import 'package:thyme_to_cook/services/auth/auth_user_storage.dart';

class FirebaseAuthProvider implements AuthProvider {
  final AuthUserStorage _authUserStorage = AuthUserStorage();

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user, {});
    } else {
      return null;
    }
  }

@override

Future<AuthUser> registerUser({
  required String email,
  required String password,
}) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic> userData = {
        "id": user.uid,
        "email": user.email,
        "username": "ThymeToCookUser",
        "isEmailVerified": user.emailVerified,
        "createDate": DateTime.now(),
        "updateDate": DateTime.now(),
        "role": "user",
        "userPreferences": [],
      };
      // Creating the user document when a user registers
      await _authUserStorage.createUserDocument(userData);
      // Initialize user collections
      await _authUserStorage.initializeUserCollections();
      return AuthUser.fromFirebase(user, userData);
    } else {
      throw UserNotLoggedInAuthException();
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'weak-password':
        throw WeakPasswordAuthException();
      case 'email-already-in-use':
        throw EmailAlreadyInUseAuthException();
      case 'invalid-email':
        throw InvalidEmailAuthException();
      default:
        throw GenericAuthException();
    }
  } catch (_) {
    throw GenericAuthException();
  }
}



  @override
  Future<AuthUser> createUserDoc({
    required String email,
    required String username,
    required Map<String, dynamic>? userPreferences,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userData = {
          "id": user.uid,
          "email": user.email,
          "username": username,
          "isEmailVerified": user.emailVerified,
          "createDate": DateTime.now(),
          "updateDate": DateTime.now(),
          "role": "user",
          "userPreferences": userPreferences ?? [],
        };
        log(username);
        // Creating the user document when a user registers
        await _authUserStorage.updateUserDocument(userData);
        return AuthUser.fromFirebase(user, userData);
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
Future<AuthUser> logIn({
  required String email,
  required String password,
}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic> userData = await _authUserStorage.getUserData();
      return AuthUser.fromFirebase(user, userData);
    } else {
      throw UserNotLoggedInAuthException();
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "invalid-credential":
        throw InvalidCredentialsAuthException();
      case '"invalid-email"':
        throw InvalidEmailAuthException();
      default:
        throw GenericAuthException();
    }
  } catch (_) {
    throw GenericAuthException();
  }
}

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

@override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

@override
Future<void> sendPasswordReset({required String toEmail}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'invalid-email':
        throw InvalidEmailAuthException();
      case 'invalid-credential':
        throw InvalidEmailAuthException();
      default:
        throw GenericAuthException();
    }
  } catch (_) {
    throw GenericAuthException();
  }
}

@override
  Future<void> refreshUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
    }
  }
}