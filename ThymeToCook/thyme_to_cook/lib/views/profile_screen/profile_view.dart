import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Profile"),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
              }, 
              icon: Icon(
                MdiIcons.cog,
                size: 30,
              )
            )
          ]
        ),
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: Icon(MdiIcons.chevronLeft),
          iconSize: 30,
        ),
      ),
      body: _profilePage(),
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
