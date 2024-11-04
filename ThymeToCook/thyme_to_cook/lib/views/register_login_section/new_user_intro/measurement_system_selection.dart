import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/main.dart';
import 'package:thyme_to_cook/models/user_model.dart';
import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';

class MeasurementSystemSelection extends StatefulWidget {
  const MeasurementSystemSelection({super.key});

  @override
  State<MeasurementSystemSelection> createState() => _MeasurementSystemSelectionState();
}

class _MeasurementSystemSelectionState extends State<MeasurementSystemSelection> {
  String? _groupValue = 'metric';

  @override
  Widget build(BuildContext context) {
     UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is GenericAuthException) {
            await showErrorDialog(context,"Failed to complete registration",);
          }
        } else if (state is AuthStateLoggedIn) {
      // Navigate to the main app screen when login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(isLoggedIn: true),
        ),
      );
    } else if (state is AuthStateNeedsVerification) {
      // Navigate to the email verification screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VerifyEmailView(),
        ),
      );
    }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              MdiIcons.chevronLeft,
            ),
            iconSize: 35,
          ),
          leadingWidth: 40,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: 4 / 4,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 162, 206, 100)),
            ),
          ),
        ),
        body: Stack(children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Measurement System",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text('Metric'),
                    leading: Radio<String>(
                      value: 'metric',
                      groupValue: _groupValue,
                      onChanged: (value) {
                        setState(() {
                          _groupValue = value;
                          Provider.of<UserProvider>(context, listen: false)
                              .updateMetricSystem(true);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Imperial'),
                    leading: Radio<String>(
                      value: 'imperial',
                      groupValue: _groupValue,
                      onChanged: (value) {
                        setState(() {
                          _groupValue = value;
                          Provider.of<UserProvider>(context, listen: false)
                              .updateMetricSystem(false);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                UserModel user = userProvider.user;
  context.read<AuthBloc>().add(
    AuthEventRegister(
      user.email!,
      user.username!,
      user.userPreferences!,
    ),
  );
  Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        ]),
      ),
    );
  }
}
