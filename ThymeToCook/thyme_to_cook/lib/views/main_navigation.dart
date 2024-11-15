import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/constants/screens.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_event.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_state.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/create_recipe_screen/create_recipe_view.dart';
import 'package:thyme_to_cook/views/grocery_list_screen/grocery_list_view.dart';
import 'package:thyme_to_cook/views/guest_user_screens/grocery_list_guest.dart';
import 'package:thyme_to_cook/views/guest_user_screens/home_view_guest.dart';
import 'package:thyme_to_cook/views/guest_user_screens/planner_guest.dart';
import 'package:thyme_to_cook/views/guest_user_screens/saved_guest.dart';
import 'package:thyme_to_cook/views/home_screen/adjusted_home_view.dart';
import 'package:thyme_to_cook/views/meal_planner_screen/meal_panner_view.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';


class MainNavigation extends StatefulWidget {
  final bool isLoggedIn;
  const MainNavigation({super.key, required this.isLoggedIn});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final currentState = context.read<NavigationBloc>().state;
    if (currentState.selectedTabIndex != 0) {
      context.read<NavigationBloc>().add(const SelectTabEvent(0));
      return false;
    } else {
      final shouldExit = await _showExitConfirmationDialog(context) ?? false;
      if (shouldExit) {
        SystemNavigator.pop();
        return true;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

     void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Recipe'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const CreateRecipeView(),
        ),);
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.calendarPlus),
              title: const Text('Add Recipe to Meal Plan'),
              onTap: () {
                // Handle add recipe to meal plan
                Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const MealPlannerView(),
        ),);
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.heartPlus),
              title: const Text('Add Recipe to Collection'),
              onTap: () {
                // Handle add recipe to collection
                Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const AdjustedSearchView(),
        ),);
              },
            ),
          ],
        );
      },
    );
  }

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        // Depending on the state of the user, change the screens shown 
        final myscreens = widget.isLoggedIn
          ? [
              ResponsiveWrapper.builder(
                const AdjustedHomeView(),
                breakpoints: const [
                  ResponsiveBreakpoint.resize(480, name: MOBILE),
                  ResponsiveBreakpoint.resize(800, name: TABLET),
                  ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                ],
              ),
              screens[1],
              const AdjustedSearchView(),
              screens[3],
              const GroceryListView(),
            ]
          : [
              ResponsiveWrapper.builder(
                const HomeGuestView(),
                breakpoints: const [
                  ResponsiveBreakpoint.resize(480, name: MOBILE),
                  ResponsiveBreakpoint.resize(800, name: TABLET),
                  ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                ],
              ),
              const SavedGuestView(),
              const AdjustedSearchView(),
              const PlannerGuestView(),
              const GroceryListGuestView()
            ];
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: Stack(
              children: [
                IndexedStack(
                index: state.selectedTabIndex,
                children: myscreens,
              ),
              widget.isLoggedIn ? Positioned(
                right: 16.0,
                bottom: 20.0,
                child: FloatingActionButton(
                  onPressed: () {
                    showBottomSheet();
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
              ) : const Text(""),
              ]
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedTabIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(SelectTabEvent(index));
              },
              backgroundColor: navigationBarColor,
              selectedItemColor: const Color.fromARGB(255, 162, 206, 100),
              unselectedItemColor: navIconColor,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.homeVariant, size: 24),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.heart, 
                    size: 24
                ),
                  label: "Saved",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.magnify, 
                    size: 24
                ),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.calendarBlank, 
                    size: 24
                ),
                  label: "Planner",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.listBox, 
                    size: 24
                ),
                  label: "Lists",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
