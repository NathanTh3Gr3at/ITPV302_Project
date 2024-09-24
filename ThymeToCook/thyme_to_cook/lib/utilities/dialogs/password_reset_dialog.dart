import 'package:flutter/material.dart';
import 'package:thyme_to_cook/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Password Reset',
      content: 'We have sent a password reset link ',
      optionBuilder: () => {
            'OK': null,
          });
}
