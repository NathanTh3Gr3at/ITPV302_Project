import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 247),
      appBar: AppBar(
        title: const Text("Profile"),
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
                              const RouteSettings(name: ProfileView.routeName)),
                    );
                  }
                  break;

                //added a settings page
                case MenuAction.settings:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
