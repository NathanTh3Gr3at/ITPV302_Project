import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
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
      AuthEventRegisterEmailAndPassword(
        email,
        password,
      ),
    );
    Provider.of<UserProvider>(context, listen: false).updateEmail(email);
  }
}

@override
Widget build(BuildContext context) {
  return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegisterEmailAndPassword) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context,"Email already in use",);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context,"Invalid email",);
          }else if (state.exception is GenericAuthException) {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
            builder: (context) => const UsernameChoiceView(),
        ),
      );
          }
        } else if (state is AuthStateRegistered) {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
          builder: (context) => const UsernameChoiceView(),
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
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(isLoggedIn: false),
                ),
              );
            },
            icon: Icon(
              MdiIcons.chevronLeft,
            ),
            iconSize: 35,
          ),
        ),
        backgroundColor: openAppBackgroundColor,
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
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Welcome User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    errorText: !_isEmailValid ? 'Please enter your email' : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: !_isPasswordValid ? 'Please enter your password' : null,
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
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const LoginView(),
                    ),
                  );
                  context.read<AuthBloc>().add(
                    const AuthEventShouldLogin(),
                  );
                },
                child: const Text("Already registered? Login here"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}










// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:thyme_to_cook/services/auth/auth_exceptions.dart';
// import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
// import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
// import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';

// import 'package:thyme_to_cook/themes/colors/colors.dart';
// import 'package:thyme_to_cook/utilities/dialogs/error_dialog.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// //Navigation fix needed
// class _RegisterViewState extends State<RegisterView> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthStateRegistering) {
//           if (state.exception is WeakPasswordAuthException) {
//             await showErrorDialog(context, 'Weak password');
//           } else if (state.exception is EmailAlreadyInUseAuthException) {
//             await showErrorDialog(context, 'Email is already in use');
//           } else if (state.exception is GenericAuthException) {
//             await showErrorDialog(context, 'Failed to register');
//           } else if (state.exception is InvalidEmailAuthException) {
//             await showErrorDialog(context, 'Invalid email address');
//           }
//         }
//       },
//       child: GestureDetector(
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           backgroundColor: openAppBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: openAppBackgroundColor,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               //crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Image(
//                   image: AssetImage('assets/images/thyme_to_cook_logo.png'),
//                   width: 300,
//                   height: 300,
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: RichText(
//                     text: const TextSpan(
//                       text: 'Welcome user!',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 40,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: RichText(
//                       text: const TextSpan(
//                         text: 'Sign Up',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 /* Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: TextField(
//                     controller: _email,
//                     enableSuggestions: false,
//                     autocorrect: false,
//                     autofocus: true,
//                     keyboardType: TextInputType.text,
//                     decoration:
//                         const InputDecoration(hintText: 'Enter username here'),
//                   ),
//                 ), */
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: TextField(
//                     controller: _email,
//                     enableSuggestions: false,
//                     autocorrect: false,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                         hintText: 'Enter your email here'),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: TextField(
//                     controller: _password,
//                     obscureText: true,
//                     enableSuggestions: false,
//                     autocorrect: false,
//                     decoration: const InputDecoration(
//                         hintText: 'Enter your password here'),
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 30, bottom: 20),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             final email = _email.text;
//                             final password = _password.text;
//                             context.read<AuthBloc>().add(
//                                   AuthEventRegister(
//                                     email,
//                                     password,
//                                   ),
//                                 );
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryButtonColor,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30))),
//                           child: const Text(
//                             'Register',
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           context.read<AuthBloc>().add(
//                                 const AuthEventLogOut(),
//                               );
//                         },
//                         child: const Text(
//                           'Already registered? Login here',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }
// }
