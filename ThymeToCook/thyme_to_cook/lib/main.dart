import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/firebase_options.dart';
import 'package:thyme_to_cook/helpers/loading/loading_screen.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/services/auth/auth_user.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/bloc/create_recipe_function/created_recipe_qubit.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/meal_planner_function/meal_planner_cubit.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
import 'package:thyme_to_cook/services/auth/firebase_auth_provider.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/forgot_password_view.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/username_choice.dart';
import 'package:thyme_to_cook/views/register_login_section/register_view.dart';
import 'package:thyme_to_cook/views/register_login_section/verify_email_view.dart';
import 'package:thyme_to_cook/views/web_views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Make sure Hive is fully initialized before creating RecipeStorage
  RecipeStorage recipeStorage = await RecipeStorage.getInstance();
  User? user = FirebaseAuth.instance.currentUser;
  AuthUser? authUser;
  if (user != null) {
    authUser = await fetchUserDetails(user);
  }
  runApp(
    ChangeNotifierProvider<AuthUser>(
      create: (context) =>
          authUser ??
          AuthUser(
            id: "guest_id",
            email: "guest_email",
            isEmailVerified: false,
            createDate: DateTime.now(),
            updateDate: DateTime.now(),
            role: "user",
            userPreferences: {},
            username: "Guest User",
          ),
      child: MyApp(recipeStorage: recipeStorage),
    ),
  );
}

Future<AuthUser> fetchUserDetails(User user) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (userDoc.exists) {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return AuthUser.fromFirebase(user, userData);
  } else {
    throw Exception('User not found in Firestore');
  }
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
        BlocProvider(create: (context) => MealPlannerCubit()),
        BlocProvider(create: (context) => CreateRecipeQubit()),
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
 
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        if (state is AuthStateLoggedIn) {
          return const MainNavigation(isLoggedIn: true);
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateRegisterUsername) {
          return const UsernameChoiceView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateLoggedOut) {
          return const MainNavigation(isLoggedIn: false);
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateLoggingIn) {
          return const LoginView();
        } else {
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
