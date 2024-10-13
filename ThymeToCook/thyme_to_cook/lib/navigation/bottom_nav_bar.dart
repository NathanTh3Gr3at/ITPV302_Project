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
        return NavigationBar(
          onDestinationSelected: (index) {
            context.read<NavigationBloc>().add(SelectTabEvent(index));
          },
          indicatorColor: navIconSelectedColor,
          selectedIndex: state.selectedTabIndex,
          backgroundColor: navigationBarColor,
          destinations: <Widget>[
            NavigationDestination(
                icon: Icon(
                  MdiIcons.homeVariant,
                  color: navIconColor,
                ),
                label: "Home"),
            NavigationDestination(
                icon: Icon(
                  MdiIcons.heart,
                  color: navIconColor,
                ),
                label: "Saved"),
            NavigationDestination(
                icon: Icon(
                  MdiIcons.magnify,
                  color: navIconColor,
                ),
                label: "Search"),
            NavigationDestination(
                icon: Icon(
                  MdiIcons.calendarBlank,
                  color: navIconColor,
                ),
                label: "Planner"),
            NavigationDestination(
                icon: Icon(
                  MdiIcons.listBox,
                  color: navIconColor,
                ),
                label: "Lists")
          ],
        );
      },
    );
  }
}
