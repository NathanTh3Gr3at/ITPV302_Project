import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';

class MealPannerView extends StatefulWidget {
  const MealPannerView({super.key});

  @override
  State<MealPannerView> createState() => _MealPannerViewState();
}

class _MealPannerViewState extends State<MealPannerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Planner"),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}