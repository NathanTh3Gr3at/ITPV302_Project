// Login Exceptions
class InvalidCredentialsAuthException implements Exception{}
class InvalidEmailAuthException implements Exception{}
// Register Exceptions
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}

// generic exceptions
class GenericAuthException implements Exception{}
class UserNotLoggedInAuthException implements Exception{}