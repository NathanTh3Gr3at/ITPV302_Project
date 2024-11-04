import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:thyme_to_cook/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateLogin extends AuthState {
  final Exception? exception;
  
  const AuthStateLogin({this.exception, required super.isLoading});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateError extends AuthState {
  final String message;

  const AuthStateError({required this.message, required super.isLoading});
}


class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateRegisterEmailAndPassword extends AuthState {
  final Exception? exception;
  const AuthStateRegisterEmailAndPassword({
    required this.exception,
    required super.isLoading,
  });
}

class AuthStateRegisterUsername extends AuthState {
  const AuthStateRegisterUsername({required super.isLoading});
}

class AuthStaterRegisterIngredientsToAvoid extends AuthState {
  const AuthStaterRegisterIngredientsToAvoid({required super.isLoading});
}

class AuthStateRegisterDiets extends AuthState {
  const AuthStateRegisterDiets({required super.isLoading});
}

class AuthStateRegisterMeasurementSystem extends AuthState {
  const AuthStateRegisterMeasurementSystem({required super.isLoading});
}

class AuthStateShouldRegister extends AuthState {
  final Exception? exception;
  const AuthStateShouldRegister({
    required this.exception,
    required super.isLoading,
  });
}

class AuthStateLoggingIn extends AuthState {
  const AuthStateLoggingIn({required super.isLoading});
}

class AuthStateRegistered extends AuthState {
  final AuthUser user;
  AuthStateRegistered(this.user, {required super.isLoading});

}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required super.isLoading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required super.isLoading,
  });
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({required this.exception, required super.isLoading});

}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText = null,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
