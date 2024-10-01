import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 247),
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
