import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/generic_dialog.dart';

Future<void> showNoInternetConnectionDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    backgroundColor: noInternetConnectionDialogColor,
    dialogIcon: const Icon(Icons.wifi_off_rounded),
    context: context,
    title: 'No Internet Connection',
    content: 'Please connect to the internet to use this feature',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
