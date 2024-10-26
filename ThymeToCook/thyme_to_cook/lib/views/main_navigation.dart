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
import 'package:thyme_to_cook/views/home_screen/adjusted_home_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

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
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: IndexedStack(
              index: state.selectedTabIndex,
              children: [
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
                screens[2],
                screens[3],
                screens[4],
              ],
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
