import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_event.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_state.dart';

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
            indicatorColor: const Color.fromARGB(206, 236, 235, 235),
            selectedIndex: state.selectedTabIndex,
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            destinations: <Widget> [
              NavigationDestination(
                icon: Icon(
                  MdiIcons.homeVariant, 
                  color: Colors.black,
                  ),
                label: "Home"
              ),
              NavigationDestination(
                icon: Icon(
                  MdiIcons.heart,
                  color: Colors.black,
                ), 
                label: "Saved"
              ),
              NavigationDestination(
                icon: Icon(
                  MdiIcons.magnify,
                  color: Colors.black,
                  ), 
                label: "Search"
              ),
              NavigationDestination(
                icon: Icon(
                  MdiIcons.calendarBlank,
                  color: Colors.black,
                  ), 
                label: "Planner"
              ),
              NavigationDestination(
                icon: Icon(
                  MdiIcons.listBox,
                  color: Colors.black,
                  ), 
                label: "Lists")
            ],
          );
      },
    );
  }
}

// return BottomNavigationBar(
//       currentIndex: selectedIndex,
//       onTap: onTabSelected,
//       selectedItemColor: Colors.black,
//       unselectedItemColor: Colors.black,
//       showUnselectedLabels: true,
//       type: BottomNavigationBarType.fixed,
      
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(MdiIcons.homeVariant),
//           label: "Home",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(MdiIcons.heart), 
//           label: "Saved",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(MdiIcons.magnify), 
//           label: "Search",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(MdiIcons.calendarBlank), 
//           label: "Planner",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(MdiIcons.listBox), 
//           label: "Lists"
//         ),
//       ]
//     );