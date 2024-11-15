import 'package:flutter/material.dart';
import 'package:thyme_to_cook/views/web_views/desktop_scaffold.dart';
import 'package:thyme_to_cook/views/web_views/mobile_scaffold.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Desktop layout
          return DesktopScaffold();
        } else {
          // Tablet and Mobile layout
          return MobileScaffold();
        }
      },
    );
  }
}

