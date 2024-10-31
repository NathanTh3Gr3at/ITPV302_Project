import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';

class MealPannerView extends StatefulWidget {
  const MealPannerView({super.key});

  @override
  State<MealPannerView> createState() => _MealPannerViewState();
}

class _MealPannerViewState extends State<MealPannerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text(
            "Meal Planner",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                //add functionality
              },
            ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                      ),
                    );
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
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
              Tab(text: 'Sun'),
            ],
          )),
     // body: TabBarView(controller: _tabController, children: List.generate(7,index){return ListView(children:[ExpansionTile(title:Text('Breakfast'),children:[ListTile(title:Text('Meal 1')),ListTile(title:Text('Meal 2'))],),ExpansionTile]);}),
    );
  }
}
