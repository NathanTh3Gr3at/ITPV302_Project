import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
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
    'Egg':false,
    'Caffeine':false,
    'Fish':false,
    'Milk':false,
    'Gluten':false,
    'Mustard':false
  };
  final Map<String, bool> _diets = {
    'Vegan':false,
    'Paleo':false,
    'Keto':false,
    'Low Carb':false,
    'Vegetarian':false,
    'Diary free':false,
    'Gluten free':false
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Settings"),
        actions: [
          // pop menu
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.menu),
            onSelected: (value) async {
              switch (value) {
                //handles logging out
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                // added menu action to go to profile view
                case MenuAction.profile:
                  if (ModalRoute.of(context)?.settings.name !=
                      ProfileView.routeName) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                        settings:
                            const RouteSettings(name: ProfileView.routeName),
                      ),
                    );
                  }
                  break;

                //added a settings page
                case MenuAction.settings:
                  if (ModalRoute.of(context)?.settings.name !=
                      SettingsView.routeName) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsView(),
                          settings: const RouteSettings(
                              name: SettingsView.routeName)),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile,
                  child: Text("User Profile"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text("Settings"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                )
                // User profile text
              ];
            },
          )
        ],
      ),
      body: _settings(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Column _settings() {
    return Column(
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
            items: <String>['Metric', 'Imperial'].map<DropdownMenuItem<String>>(
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
      ],
    );
  }
}
