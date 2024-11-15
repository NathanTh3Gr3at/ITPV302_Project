import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/grocery_list_screen/grocery_list_view.dart';
import 'package:thyme_to_cook/views/meal_planner_screen/meal_panner_view.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/save_screen/save_view.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';
import 'package:thyme_to_cook/views/web_views/laptop.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold>  with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            const Text("Thyme to Cook"),
            const SizedBox(width: 20),
            Expanded(
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Home"),
                  Tab(text: "Saved"),
                  Tab(text: "Search"),
                  Tab(text: "Planner"),
                  Tab(text: "Lists"),
                ],
                indicatorColor: const Color.fromARGB(255, 218, 218, 218),
                dividerColor: Colors.transparent,
              ),
            ),
          ],
        ),

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
                    // ignore: use_build_context_synchronously
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
      body: TabBarView(
        controller: _tabController,
        children:[
          const Center(child: LaptopHomePageView()),
          Center(child: ResponsiveWrapper.builder(
                              const SaveView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
          Center(child: ResponsiveWrapper.builder(
                              const AdjustedSearchView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
          Center(child: ResponsiveWrapper.builder(
                              const MealPlannerView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
          Center(child: ResponsiveWrapper.builder(
                              const GroceryListView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
        ],
      ));
  }
}

