import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/constants/screens.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_bloc.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_state.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        switch (state.selectedTabIndex) {
            case 0: 
              return screens[0];
            case 1:
              return screens[1];
            case 2:
              return screens[2];
            case 3:
              return screens[3];
            case 4:
              return screens[4];
            default:
              return screens[0];
          }
      },
      
    );
  }
}