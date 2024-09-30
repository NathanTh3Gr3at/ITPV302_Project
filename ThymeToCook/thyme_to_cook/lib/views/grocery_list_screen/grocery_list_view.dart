import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';

class GroceryListView extends StatefulWidget {
  const GroceryListView({super.key});

  @override
  State<GroceryListView> createState() => _GroceryListViewState();
}

class _GroceryListViewState extends State<GroceryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}