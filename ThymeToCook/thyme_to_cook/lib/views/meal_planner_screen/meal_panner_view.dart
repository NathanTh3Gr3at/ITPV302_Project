import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

class _MealPannerViewState extends State<MealPannerView> {
  DateTime selectedDate = DateTime.now();
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _previousDay),
                  Text(
                    DateFormat('EEEE,MMM d,yyyy').format(selectedDate),
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: _nextDay,
                    icon: const Icon(Icons.arrow_forward),
                  )
                ],
              );
            }),
          ),
        ),
        body: _buildMealList());
  }

  Widget _buildMealList() {
    return ListView(
      children: const [
        ExpansionTile(
          title: Text('BreakFast'),
          children: [
            ListTile(title: Text('meal1')),
            ListTile(title: Text('meal2')),
          ],
        ),
        ExpansionTile(
          title: Text('Lunch'),
          children: [
            ListTile(title: Text('meal1')),
            ListTile(title: Text('meal2')),
          ],
        ),
        ExpansionTile(
          title: Text('Dinner'),
          children: [
            ListTile(title: Text('meal1')),
            ListTile(title: Text('meal2')),
          ],
        )
      ],
    );
  }
}
