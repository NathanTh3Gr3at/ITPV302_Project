import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';

class OpenAppView extends StatefulWidget {
  const OpenAppView({super.key});

  @override
  State<OpenAppView> createState() => _OpenAppViewState();
}

class _OpenAppViewState extends State<OpenAppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: openAppBackgroundColor,
      appBar: AppBar(
        backgroundColor: openAppBackgroundColor,
      ),
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Image(
                image: AssetImage('assets/images/thyme_to_cook_logo.png'),
                width: 350,
                height: 350,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: const TextSpan(
                text: 'Welcome',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>const LoginView()));
                
                /* context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    ); */
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButtonColor,
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventShouldRegister(),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryButtonColor,
            ),
            child: const Text(
              "Register",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
