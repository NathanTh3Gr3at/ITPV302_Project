import 'package:flutter/material.dart';
import 'package:thyme_to_cook/utilities/dialogs/generic_dialog.dart';

Future<bool> showLoginPrompt(BuildContext context) async {
  final login = await showGenericDialog<bool>(
    context: context,
    title: 'Save Recipe',
    content: 'Please log in to save recipes.',
    optionBuilder: () => {
      'OK': false,
      'Log In': true,
    },
    backgroundColor: Colors.teal[50],
  );

  return login ?? false;
}