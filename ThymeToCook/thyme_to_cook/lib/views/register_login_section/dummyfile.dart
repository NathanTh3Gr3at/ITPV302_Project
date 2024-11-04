import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/main.dart';
import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/ingredients_to_avoid.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/username_choice.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
    }
    else {
      final email = _email.text;
      final password = _password.text;
                            // Replace with register Step state
                            // context.read<AuthBloc>().add(
                            //       AuthEventRegister(
                            //         email,
                            //         password,
                            //   ),
                            // );
      Provider.of<UserProvider>(context, listen: false).updateEmail(email);
      Provider.of<UserProvider>(context, listen: false).updatePassword(password);
      context.read<AuthBloc>().add(const AuthEventRegisterIgredientsToAvoid());
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const UsernameChoiceView(),
             ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateShouldRegister) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email address');
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: openAppBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Image(
                  image: AssetImage('assets/images/thyme_to_cook_logo.png'),
                  width: 300,
                  height: 300,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: const TextSpan(
                      text: 'Welcome user!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  errorText: !_isEmailValid ? 'Please enter your email address' : null,
                  errorStyle: const TextStyle(
                    color: errorMessagesAndAlertsColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: !_isEmailValid ? errorMessagesAndAlertsColor : Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: !_isEmailValid ? errorMessagesAndAlertsColor : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: !_isPasswordValid ? 'Please enter your password' : null,
                  errorStyle: const TextStyle(
                    color: errorMessagesAndAlertsColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: !_isPasswordValid ? errorMessagesAndAlertsColor : Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: !_isPasswordValid ? errorMessagesAndAlertsColor : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20.0),
                //   child: TextField(
                //     controller: _password,
                //     obscureText: true,
                //     enableSuggestions: false,
                //     autocorrect: false,
                //     decoration: const InputDecoration(
                //         hintText: 'Enter your password here'),
                //     // decoration: const InputDecoration(
                //     //     hintText: 'Enter your password here',
                //     //     labelText: "Password",
                //     //     filled: true,
                //     //     fillColor: openAppBackgroundColor
                //     // ),    
                //   ),
                // ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            _validateCredentialsAndProceed();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryButtonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            const AuthEventShouldLogin(),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const LoginView(),
                            ),
                        );
                        },
                        child: const Text(
                          'Already registered? Login here',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
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

