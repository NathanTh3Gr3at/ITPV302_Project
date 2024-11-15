import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    backgroundColor: errorMessagesAndAlertsColor,
    dialogIcon: const Icon(Icons.warning_rounded),
    context: context,
    title: 'An error occurred',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
