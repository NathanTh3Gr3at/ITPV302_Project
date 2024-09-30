import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';

class SaveView extends StatefulWidget {
  const SaveView({super.key});

  @override
  State<SaveView> createState() => _SaveViewState();
}

class _SaveViewState extends State<SaveView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Recipes")
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}