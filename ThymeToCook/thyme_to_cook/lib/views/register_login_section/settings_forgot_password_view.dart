import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';
import 'package:thyme_to_cook/utilities/dialogs/password_reset_dialog.dart';

class SettingsForgotPasswordView extends StatefulWidget {
  const SettingsForgotPasswordView({super.key});

  @override
  State<SettingsForgotPasswordView> createState() => _SettingsForgotPasswordViewState();
}

class _SettingsForgotPasswordViewState extends State<SettingsForgotPasswordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step.');
          }
        }
      },
      child: GestureDetector(
        onTap:()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: const Text('Forgot Password?'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                    'If you forgot your password, simply enter your email and we will send you a password reset link.'),
                Padding(
                  padding: const EdgeInsets.only(top:30,bottom:30),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    //autofocus: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Your email address....',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      final email = _controller.text;
                      context
                          .read<AuthBloc>()
                          .add(AuthEventForgotPassword(email: email));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Send me password reset link'),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}