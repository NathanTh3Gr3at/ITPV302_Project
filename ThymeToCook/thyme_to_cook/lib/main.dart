import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/src/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
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
// import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/views/home_screen/adjusted_home_view.dart';
// import 'package:thyme_to_cook/views/home_screen/home_view.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/save_screen/save_view.dart';
// import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';
// import 'package:thyme_to_cook/views/register_login_section/new_user_intro/dietary_selection.dart';
// import 'package:thyme_to_cook/views/register_login_section/new_user_intro/ingredients_to_avoid.dart';
// import 'package:thyme_to_cook/views/register_login_section/new_user_intro/measurement_system_selection.dart';
// import 'package:thyme_to_cook/views/register_login_section/forgot_password_view.dart';
// import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
// import 'package:thyme_to_cook/views/register_login_section/open_app_view.dart';
// import 'package:thyme_to_cook/views/register_login_section/register_view.dart';
// import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';
// import 'package:thyme_to_cook/views/save_screen/save_view.dart';
// import 'package:thyme_to_cook/views/search_screen/search_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);  // initializes firebase with current platform
  
  // final searchRepo = FirebaseSearch(); // used for searching
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => MeasurementSystemBloc()),
        BlocProvider(create: (context) => DietaryPreferencesBloc()), 
         
        // BlocProvider(create: (context) => SearchBloc(searchRepo: searchRepo)), 
      ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(
          child, 
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.resize(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ]
        ),
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

class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<InternetStatus> _internetSubscription;  
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();

    // Subscribe to changes in connection status after the initial check
    _internetSubscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (status == InternetStatus.connected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Welcome back online!"),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (status == InternetStatus.disconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Device disconnected!"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    });

    _checkInitialConnectionStatus();
  }

  Future<void> _checkInitialConnectionStatus() async {
    // Check the initial connection status synchronously
    final initialStatus = await Connectivity().checkConnectivity();
    if (initialStatus == InternetStatus.disconnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Device disconnected!"),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }
  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }
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

          return ResponsiveWrapper.builder(
            const MainNavigation(),
            breakpoints: const [
                ResponsiveBreakpoint.resize(480, name: MOBILE),
                ResponsiveBreakpoint.resize(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ]
          );// starts at HomeView
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
