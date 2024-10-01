import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 247),


      appBar: AppBar(
        title: const Text("Settings")
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}