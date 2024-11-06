import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/firebase_options.dart';
import 'package:thyme_to_cook/helpers/loading/loading_screen.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
// import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/forgot_password_view.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/username_choice.dart';
// import 'package:thyme_to_cook/views/register_login_section/open_app_view.dart';
import 'package:thyme_to_cook/views/register_login_section/register_view.dart';
import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';
import 'package:thyme_to_cook/views/web_views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Make sure Hive is fully initialized before creating RecipeStorage
  RecipeStorage recipeStorage = await RecipeStorage.getInstance();

  runApp(
    MyApp(recipeStorage: recipeStorage),
  );
}


class MyApp extends StatelessWidget {
  final RecipeStorage recipeStorage;

  const MyApp({super.key, required this.recipeStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(create: (context) => NavigationBloc()),
        // handles bloc provider error usually
        BlocProvider(create: (context) => GroceryListBloc()),
        BlocProvider(create: (context) => SaveRecipeCubit()),
       
        Provider<RecipeStorage>.value(value: recipeStorage),
      ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.resize(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            headlineMedium: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Poppins',
            ),
            bodySmall: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Poppins',
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: kIsWeb ? const HomeScreenWeb() : const HomePage(),
      ),
    );
  }
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
    // Checks if this is the users first time
    // checkFirstTime();
    // Subscribe to changes in connection status after the initial check
    _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      bool currentlyConnected = (status == InternetStatus.connected);
      if (currentlyConnected != isFirstTime) {
        isFirstTime = currentlyConnected;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(currentlyConnected
                ? "Welcome back online!"
                : "Device disconnected"),
            duration: const Duration(seconds: 3),
          ));
        });
      }
    });
  }

  // Future<void> inspectHiveBox() async {
  // var box = await Hive.openBox<CloudRecipe>('recipes');
  // log('Hive box length: ${box.length}');
  // for (var recipe in box.values) {
  //   log('Recipe: ${recipe.recipeName}');
  // }
  // }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }
  //  Future<void> checkFirstTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool hasOpenedAppBefore = prefs.getBool('hasOpenedAppBefore') ?? false;

  //   if (!hasOpenedAppBefore) {
  //     await prefs.setBool('hasOpenedAppBefore', true);
  //     context.read<AuthBloc>().add(const AuthEventLogOut());
  //   }
  // }

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
      if (state is AuthStateLoggedIn) {
        return const MainNavigation(isLoggedIn: true);
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateRegisterUsername) {
        return const UsernameChoiceView();
      } else if (state is AuthStateForgotPassword) {
        return  const ForgotPasswordView();
      } else if (state is AuthStateLoggedOut) {
        return const MainNavigation(isLoggedIn: false);
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else if (state is AuthStateLoggingIn) {
        return const LoginView();
      }
      else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  );
}
}
        //the original
         

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


    /* _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
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
    }); */

    // _checkInitialConnectionStatus();
  // }

  // Future<void> _checkInitialConnectionStatus() async {
  //   // Check the initial connection status synchronously
  //   final initialStatus = await Connectivity().checkConnectivity();
  //   if (initialStatus == ConnectivityResult.none) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Device disconnected from WIFI!"),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     });
  //   }
  // }

  // To Handle the UI changes when Connected/Disconnected
  // void _updateUIBasedOnConnectivity(bool isConnected) {
  //   if (isConnected) {
  //   } else {}
  // }