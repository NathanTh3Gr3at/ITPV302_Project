import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thyme_to_cook/helpers/loading/loading_screen.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/bloc/dietary_preferences/dietary_preferences_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/measurement_system/measurement_system_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
// import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/forgot_password_view.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/new_user_preference_selection.dart';
import 'package:thyme_to_cook/views/register_login_section/open_app_view.dart';
import 'package:thyme_to_cook/views/register_login_section/register_view.dart';
import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.android);  
  // Already initialized in Firebase Auth
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);  
  
  // Registering all the recipe, instruction and ingredient hives
  await Hive.initFlutter();
  Hive.registerAdapter(CloudRecipeAdapter());
  Hive.registerAdapter(RecipeIngredientAdapter());
  Hive.registerAdapter(RecipeInstructionsAdapter());

  // Initilize recipe storage in main so the rest of the application has access to the recipes
  var recipeStorage = await RecipeStorage.getInstance();
  
  // final searchRepo = FirebaseSearch(); // used for searching
  
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => MeasurementSystemBloc()),
        BlocProvider(create: (context) => DietaryPreferencesBloc()), 
        // So Recipe Storage is available across our app --> Access to cached recipes 
        Provider<RecipeStorage>.value(value: recipeStorage), 
        BlocProvider(create: (context) => SearchBloc()), 
      ],
      child: MaterialApp(
        builder: (context, child) =>
            ResponsiveWrapper.builder(child, breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.resize(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ]),
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
        routes: {'/preferences': (context) => const PreferencesScreen()},
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

    _checkInitialConnectionStatus();
  }

  Future<void> _checkInitialConnectionStatus() async {
    // Check the initial connection status synchronously
    final initialStatus = await Connectivity().checkConnectivity();
    if (initialStatus == ConnectivityResult.none) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Device disconnected from WIFI!"),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  // To Handle the UI changes when Connected/Disconnected
  void _updateUIBasedOnConnectivity(bool isConnected) {
    if (isConnected) {
    } else {}
  }


  Future<void> inspectHiveBox() async {
  var box = await Hive.openBox<CloudRecipe>('recipes');
  log('Hive box length: ${box.length}');
  for (var recipe in box.values) {
    log('Recipe: ${recipe.recipeName}');
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
      listener: (context, state) async {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
        if (state is AuthStateNeedsVerification) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VerifyEmailView()),
          );
        } else if (state is AuthStateLoggedIn) {
          final prefs = await SharedPreferences.getInstance();
          bool preferencesSet = prefs.getBool('preferences_set') ?? false;
          if (!preferencesSet) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PreferencesScreen()),
            );
          } else {
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigation()),
            );
          }
        }
      },
      builder: (context, state) {
        Widget child;
        if (state is AuthStateLoggedIn) {
          child = const MainNavigation();
        } else if (state is AuthStateNeedsVerification) {
          child = const VerifyEmailView();
        } else if (state is AuthStateForgotPassword) {
          child = const ForgotPasswordView();
        } else if (state is AuthStateLoggedOut) {
          child = const OpenAppView();
          //OpenAppView is a new screen for the intro to app
        } else if (state is AuthStateRegistering) {
          child = const RegisterView();
          //will need to add the routing to the 3 screens
        } else {
          child = const Scaffold(
            body: CircularProgressIndicator(),
          );
        }

        return ResponsiveWrapper.builder(child, breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.resize(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ]); // starts at HomeView

        //the original
        /* return ResponsiveWrapper.builder(const MainNavigation(),
            breakpoints: const [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.resize(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ]); */

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
