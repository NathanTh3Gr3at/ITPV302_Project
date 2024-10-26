import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_event.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_state.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.selectedTabIndex,
          onTap: (index) {
            context.read<NavigationBloc>().add(SelectTabEvent(index));
          },
          backgroundColor: navigationBarColor,
          selectedItemColor: const Color.fromARGB(255, 162, 206, 100),
          unselectedItemColor: navIconColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.homeVariant,
                size: 24
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.heart,
                size: 24,
              ),
              label: "Saved",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.magnify,
                size: 24,
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
        );
      },
    );
  }
}
