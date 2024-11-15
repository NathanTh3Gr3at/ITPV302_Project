 import 'package:flutter/material.dart';
import 'package:thyme_to_cook/views/grocery_list_screen/grocery_list_view.dart';
import 'package:thyme_to_cook/views/home_screen/home_view.dart';
import 'package:thyme_to_cook/views/meal_planner_screen/meal_panner_view.dart';
import 'package:thyme_to_cook/views/save_screen/save_view.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';

final List<Widget> screens = [
  const HomeView(),
  const SaveView(),
  const AdjustedSearchView(),
  const MealPlannerView(),
  const GroceryListView(),
]; 