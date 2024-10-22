import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/auth_user.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';

import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: backgroundColor,
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
      body: _profilePage(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Column _profilePage() {
    return Column(children: [
      _profileSection(),
      const SizedBox(
        height: 20,
      ), // distance from searchbar
      _userActivity(),
      const SizedBox(
        height: 40,
      ),
    ] //
        );
  }

  Column _profileSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          
                          //user profile image
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/images/placeholder_image.jpg"),
                          ),
                        ),
                      ),

                      // spacing edit profile button
                      SizedBox(
                        height: 35,
                        child: TextButton(
                          onPressed: () {},
                          // styles the button
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            backgroundColor: iconColor,
                          ),
                          child: const Text(
                            'Edit profile',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // section for user details, must fill in
                  const Text("User"),
                  
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _userActivity() {
    return const Column(
      children: [
        Column(
          children: [
            DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // tab sections
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text("Kitchen Activity"),
                        ),
                        Tab(
                          child: Text("Recipes Created"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                          // text under each tab
                          children: [
                            Card(
                              // color: Color.fromARGB(255, 252, 253, 242),
                              // elevation: 5,
                              child: Center(
                                child: Text("Kitchen Activity"),
                              ),
                            ),
                            Card(
                              child: Center(
                                child: Text("Recipes Created"),
                              ),
                            ),
                          ],),
                    )
                  ],
                ),)
          ],
        )
      ],
    );
  }
}
