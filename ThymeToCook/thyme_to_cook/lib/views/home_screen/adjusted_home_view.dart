import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/gluten_free_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/keto_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/low_carb_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/low_sodium_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/paleo_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/pescatarian_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/vegan_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/Tabs/vegetarian_tab_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/recommended_view.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/sections/daily_delights_view.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';


class AdjustedHomeView extends StatefulWidget {
  const AdjustedHomeView({super.key});
  @override
  State<AdjustedHomeView> createState() => _AdjustedHomeViewState();
}

class _AdjustedHomeViewState extends State<AdjustedHomeView> with TickerProviderStateMixin{
  late TabController _tabController;
  late TabController _disTabController;
  bool isOffline = false;
  
@override
  void initState() {
    super.initState();
    
    // Initialize the tab controllers
    _tabController = TabController(length: 6, vsync: this);
    _disTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _disTabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final myDay = TimeOfDay.fromDateTime(DateTime.now());
    String greeting() {
      if (myDay.hour > 18) {
        return "Good Evening";
      } else if (myDay.hour > 12) {
        return "Good Afternoon";
      } else {
        return "Good Morning";
      }
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: const Color.fromARGB(255, 162, 206, 100),
        shape: const CircleBorder(),
        elevation: 20,
        child: Icon(
          MdiIcons.plus,
          color: const Color.fromARGB(255, 255, 255, 255),
          size: 30,
          ),
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          greeting(),
          style: const TextStyle(
              color: Color.fromARGB(255, 2, 2, 2),
              fontSize: 27,
              fontWeight: FontWeight.bold,
        )
      ),
      backgroundColor: const Color.fromARGB(255, 230, 236, 221),
      actions: [
          // pop menu
          PopupMenuButton<MenuAction>(
            icon: Container(
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 255, 255, 255),
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(MdiIcons.account, size: 30,)
            ),
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
        ],),
      body: RefreshIndicator(
        onRefresh: () async {
        },
        child: SingleChildScrollView(
          child: ResponsiveRowColumn(
            layout: ResponsiveWrapper.of(context).isSmallerThan('4K')
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              const ResponsiveRowColumnItem(
                child: SizedBox(
                  height: 20,
                )
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 16, left: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Daily Delights",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color:  Color.fromARGB(255, 0, 0, 0)
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 25, left: 16),
                          child: const DailyDelightsView(),
                        ),
                      ),  
                    ],
                  ),
                ),
              ),
              const ResponsiveRowColumnItem(
                child: SizedBox(
                  height: 20,
                )
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 16, left: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Healthly Recipes",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color:  Color.fromARGB(255, 0, 0, 0)
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 20),
                        child: TabBar(
                                    controller: _disTabController,
                                    indicatorColor:  const Color.fromARGB(122, 0, 0, 0),
                                    labelColor: const Color.fromARGB(122, 0, 0, 0),
                                    unselectedLabelColor: const Color.fromARGB(121, 138, 133, 133),
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    dividerColor: Colors.transparent,
                                    
                                    tabs: const [
                                        Tab(text: "Low-Carb"), 
                                        Tab(text: "Low-Sodium"),
                                ],
                              ),
                      ),  
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 25, left: 16),
                          child: TabBarView(
                            controller: _disTabController,
                            children: const [
                              LowCarbTabView(),
                              LowSodiumTabView(),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ResponsiveRowColumnItem(
                child: SizedBox(
                  height: 20,
                )
              ),
              // Second Container
              ResponsiveRowColumnItem(
                child: Container(
                  height: 310,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5, top: 20, left: 2),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Search By Ingredients",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 25, left: 16),
                          child: const RecommendedView(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ResponsiveRowColumnItem(
                child: SizedBox(
                  height: 20
                )
              ),
              // Third Container
              ResponsiveRowColumnItem(
                child: Container(
                  height: 310,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 14, top: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Recently Viewed",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const RecommendedView(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ResponsiveRowColumnItem(
                child: SizedBox(
                  height: 20,
                )
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 16, left: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Explore Diets",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color:  Color.fromARGB(255, 0, 0, 0)
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 20),
                        child: TabBar(
                                    controller: _tabController,
                                    indicatorColor:  const Color.fromARGB(122, 0, 0, 0),
                                    labelColor: const Color.fromARGB(122, 0, 0, 0),
                                    unselectedLabelColor: const Color.fromARGB(121, 138, 133, 133),
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    dividerColor: Colors.transparent,
                                    
                                    tabs: const [
                                        Tab(text: "Vegan"), 
                                        Tab(text: "Vegetarian"),
                                        Tab(text: "Paleo"),
                                        Tab(text: "Keto"),
                                        Tab(text: "Gluten Free"),
                                        Tab(text: "Pescatarian"),
                                ],
                              ),
                      ),  
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 25, left: 16),
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              VeganTabView(),
                              VegetarianTabView(),
                              PaleoTabView(),
                              KetoTabView(),
                              GlutenFreeTabView(),
                              PescatarianTabView()
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
            
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar()
    );
  }
}
