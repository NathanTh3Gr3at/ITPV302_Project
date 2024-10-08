import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/helpers/loading/loading_screen.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
import 'package:thyme_to_cook/views/register_login_section/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(create: (context) => NavigationBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, //removes debug label on top-right corner
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
            headlineMedium: TextStyle(
                fontSize: 36.0,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins'),
            bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      )));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        // return const RegisterView()
        return const MainNavigation(); // starts at HomeView
        /* if (state is AuthStateLoggedIn) {
          return const RegisterView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        } */
      },
    );
  }
}
