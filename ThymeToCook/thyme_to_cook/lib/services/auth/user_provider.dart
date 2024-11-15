import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:thyme_to_cook/models/user_model.dart';

class UserProvider with ChangeNotifier {
  final UserModel _user = UserModel();

  UserModel get user => _user;

  void updateEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _user.password = password;
    notifyListeners();
  }

  void updateUsername(String username) {
    _user.username = username;
    notifyListeners();
  }

  void updateAllergens(String allergen) {
    _user.userPreferences ??= {"allergens": [], "diet": [], "system": true};
    List<dynamic> allergens = _user.userPreferences!["allergens"] as List<dynamic>;
    if (allergens.contains(allergen)) {
      allergens.remove(allergen);
    } else {
      allergens.add(allergen);
    }
    log(allergens.toString());
    notifyListeners();
  }

  void updateDiet(String diet) {
    _user.userPreferences ??= {"allergens": [], "diet": [], "system": true};
    List<dynamic> diets = _user.userPreferences!["diet"] as List<dynamic>;
    if (diets.contains(diet)) {
      diets.remove(diet);
    } else {
      diets.add(diet);
    }
    log(diets.toString());
    notifyListeners();
  }

  void updateMetricSystem(bool isMetric) {
    _user.userPreferences ??= {"allergens": [], "diet": [], "system": true};
    _user.userPreferences!["system"] = isMetric;
    log(_user.userPreferences.toString());
    notifyListeners();
  }

  void updateUserPreferences(Map<String, dynamic> userPreferences) {
    _user.userPreferences = userPreferences;
    notifyListeners();
  }
}
