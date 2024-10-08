import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';

import 'package:thyme_to_cook/themes/colors/colors.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you have'nt received a verification email yet, press the button below."),
          ElevatedButton(
            onPressed: () {
              context.read()<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Send email verification'),
          ),
          ElevatedButton(
            onPressed: () async {
              context.read()<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
