class UserModel {
  String? email;
  String? password;
  String? username;
  Map<String, dynamic>? userPreferences;

  UserModel({this.email, this.password, this.username, this.userPreferences});
}
