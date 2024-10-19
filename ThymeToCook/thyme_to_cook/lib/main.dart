import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:thyme_to_cook/features/search/firebase_search.dart';
import 'package:thyme_to_cook/features/search/search_domain.dart';
import 'package:thyme_to_cook/firebase_options.dart';
import 'package:thyme_to_cook/helpers/loading/loading_screen.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/bloc/dietary_preferences/dietary_preferences_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/measurement_system/measurement_system_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/views/home_screen/home_view.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/dietary_selection.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/ingredients_to_avoid.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/measurement_system_selection.dart';
import 'package:thyme_to_cook/views/register_login_section/forgot_password_view.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
import 'package:thyme_to_cook/views/register_login_section/open_app_view.dart';
import 'package:thyme_to_cook/views/register_login_section/register_view.dart';
import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';
import 'package:thyme_to_cook/views/save_screen/save_view.dart';
import 'package:thyme_to_cook/views/search_screen/search_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);  // initializes firebase with current platform
  final searchRepo = FirebaseSearch(); // used for searching
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => MeasurementSystemBloc()),
        BlocProvider(create: (context) => DietaryPreferencesBloc()), 
         
        BlocProvider(create: (context) => SearchBloc(searchRepo: searchRepo)), 
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
      ),
    ),
  );
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
        //Nathan - add the new user intro section to the nav stuff

          return const MainNavigation();  // starts at HomeView
        // if (state is AuthStateLoggedIn) {
        //   return const MainNavigation();
        // } else if (state is AuthStateNeedsVerification) {
        //   return const VerifyEmailView();
        // } else if (state is AuthStateForgotPassword) {
        //   return const ForgotPasswordView();
        // } else if (state is AuthStateLoggedOut) {
        //   //return const OpenAppView();
        // //OpenAppView is a new screen for the intro to app
        //   return const LoginView();
        // } else if (state is AuthStateRegistering) {
        //   return const RegisterView();
        //   //will need to add the routing to the 3 screens
        // } else {
        //   return const Scaffold(
        //     body: CircularProgressIndicator(),
        //   );
        // }
      },
    );
  }
}
