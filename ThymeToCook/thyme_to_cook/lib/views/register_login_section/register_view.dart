import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
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
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('assets/images/placeholder_image.jpg'),
                width: 250,
                height: 250,
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
              //error overflow of text need to fix it
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(hintText: 'Enter username here'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email here'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password here'),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read()<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 87, 132, 155),
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
                              const AuthEventLogOut(),
                            );
                      },
                      child: const Text('Already registered? Login here'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
