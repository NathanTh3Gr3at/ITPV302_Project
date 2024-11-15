import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(
    this.email,
    this.password,
  );
}

class AuthEventGuestUser extends AuthEvent {
  const AuthEventGuestUser();
}

class AuthEventShouldLogin extends AuthEvent {
    const AuthEventShouldLogin();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegisterEmailAndPassword extends AuthEvent{
  final String email;
  final String password;
  const AuthEventRegisterEmailAndPassword(this.email, this.password);
}

class AuthEventRegisterUsername extends AuthEvent{
  const AuthEventRegisterUsername();
}

class AuthEventRegisterIgredientsToAvoid extends AuthEvent{
  const AuthEventRegisterIgredientsToAvoid();
}

class AuthEventRegisterDiets extends AuthEvent{
  const AuthEventRegisterDiets();
}

class AuthEventRegisterMeasurementSystem extends AuthEvent {
  const AuthEventRegisterMeasurementSystem();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String username;
  final Map<String, dynamic> userPreferences;
  const AuthEventRegister(this.email, this.username, this.userPreferences);
}

class AuthEventShouldRegister extends AuthEvent {
  
  const AuthEventShouldRegister();
}
class AuthEventForgotPassword extends AuthEvent{
  final String? email;

  const AuthEventForgotPassword({this.email});

}

class AuthEventUserProfile extends AuthEvent {
  const AuthEventUserProfile();
}