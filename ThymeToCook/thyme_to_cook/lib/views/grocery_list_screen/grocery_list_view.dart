import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';

class GroceryListView extends StatefulWidget {
  const GroceryListView({super.key});

  @override
  State<GroceryListView> createState() => _GroceryListViewState();
}

class _GroceryListViewState extends State<GroceryListView> {
  final List<_IngredientItem> _ingredients = []; //list of ingredients

  @override
  void initState() {
    super.initState();
    _initializeIngredients(); // add ingredients to list
  }

  void _initializeIngredients() {
    //replace with other code for now just to test
    _addIngredient('Cooking oil');
    _addIngredient('Olive oil');
    _addIngredient('Flour');
  }

  void _addIngredient(String ingredient) {
    setState(() {
      _ingredients.add(_IngredientItem(name: ingredient));
    });
  }

  void _toggleIngredientStatus(int index) {
    setState(() {
      _ingredients[index].isBought = !_ingredients[index].isBought;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Grocery List",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              //add functionality
            },
          ),
          // pop menu
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.menu),
            onSelected: (value) async {
              switch (value) {
                //handles logging out
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                // added menu action to go to profile view
                case MenuAction.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileView(),
                    ),
                  );
                //added a settings page
                case MenuAction.settings:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile,
                  child: Text("User Profile"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text("Settings"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                )
                // User profile text
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _ingredients.isEmpty
            ? const Center(child: Text('No ingredients to buy'))
            : ListView.builder(
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _ingredients[index];
                  return ListTile(
                    title: Text(
                      ingredient.name,
                      style: TextStyle(
                        decoration: ingredient.isBought
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: ingredient.isBought ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      ingredient.isBought
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: ingredient.isBought ? Colors.green : Colors.grey,
                    ),
                    onTap: () => _toggleIngredientStatus(index),
                  );
                },
              ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class _IngredientItem {
  final String name;
  bool isBought;
  _IngredientItem({required this.name, this.isBought = false});
}
