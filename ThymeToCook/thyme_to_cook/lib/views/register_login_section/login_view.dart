import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/register_view.dart';
import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  void _validateCredentialsAndProceed() {
    if (_email.text.isEmpty && _password.text.isEmpty) {
      setState(() {
        _isEmailValid = false;
        _isPasswordValid = false;
      });
    } else if (_email.text.isEmpty) {
      setState(() {
        _isEmailValid = false;
      });
    } else if (_password.text.isEmpty) {
      setState(() {
        _isPasswordValid = false;
      });
    } else {
      final email = _email.text;
      final password = _password.text;
      context.read<AuthBloc>().add(
            AuthEventLogIn(
              email,
              password,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidCredentialsAuthException) {
            await showErrorDialog(context, "Invalid Credentials");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid Email");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication error");
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
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MainNavigation(isLoggedIn: false),
                  ),
                );
              },
              icon: Icon(
                MdiIcons.chevronLeft,
              ),
              iconSize: 35,
            ),
            leadingWidth: 40,
          ),
          backgroundColor: openAppBackgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Image(
                  image: AssetImage('assets/images/thyme_to_cook_logo.png'),
                  width: 300,
                  height: 300,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      errorText:
                          !_isEmailValid ? 'Please enter your email' : null,
                      errorStyle: const TextStyle(
                        color: errorMessagesAndAlertsColor,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: !_isPasswordValid
                          ? 'Please enter your password'
                          : null,
                      errorStyle: const TextStyle(
                        color: errorMessagesAndAlertsColor,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ElevatedButton(
                    onPressed: _validateCredentialsAndProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Register Now"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
