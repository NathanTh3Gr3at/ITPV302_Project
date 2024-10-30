import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/new_user_preference_selection.dart';

/*  Future<void> checkPreferencesSectionCompletion(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? completed = prefs.getBool('preferencesCompleted');
  if (completed == true) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigation(),
      ),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PreferencesScreen(preferencesService: preferencesService,),
      ),
    );
  }
}

Future<void> markPreferencesCompleted() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('preferencesCompleted', true);
}   */