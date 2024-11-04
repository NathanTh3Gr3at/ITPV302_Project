import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/main.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';

class SettingsView extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _selectedUnit = 'Metric';
  //need to fix overflow error (bottom overflow)
  final Map<String, bool> _ingredients = {
    'Egg': false,
    'Caffeine': false,
    'Fish': false,
    'Milk': false,
    'Gluten': false,
    'Mustard': false
  };
  final Map<String, bool> _diets = {
    'Vegan': false,
    'Paleo': false,
    'Keto': false,
    'Low Carb': false,
    'Vegetarian': false,
    'Diary free': false,
    'Gluten free': false
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Settings"),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: Icon(MdiIcons.chevronLeft),
          iconSize: 30,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Account Section
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password'),
                trailing: TextButton(
                  onPressed: () {
                    context.read()<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const Divider(),
          
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text('Measurement Units'),
                subtitle: const Text('Select your preferred units'),
                trailing: DropdownButton<String>(
                  value: _selectedUnit,
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        _selectedUnit = newValue!;
                      },
                    );
                  },
                  items:
                      <String>['Metric', 'Imperial'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
              ExpansionTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('Dietary preferences'),
                children: _diets.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _diets[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _diets[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              ExpansionTile(
                leading: const Icon(Icons.warning),
                title: const Text('Select Ingredients'),
                children: _ingredients.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _ingredients[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _ingredients[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Log Out'),
                trailing: TextButton(
                  onPressed: () async {
                    final shouldLogOut = await showLogOutDialog(context);
                    if (shouldLogOut) {
                        context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(isLoggedIn: false,),
                      ),
                  );
                  }
                  },
                  child: const Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 /*  Column _settings() {
    return 
  }
}
 */