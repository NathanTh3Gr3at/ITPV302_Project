 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/models/category_model.dart';
import 'package:thyme_to_cook/models/recipe_viewed.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<CategoryModel> categories = [];
  List<ViewedRecipeModel> viewedRecipes = [];

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  void _getRecipes() {
    viewedRecipes = ViewedRecipeModel.getRecipes();
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  // gets info of categories and viewed recipes
  void _getInitial() {
    categories = CategoryModel.getCategories();
    viewedRecipes = ViewedRecipeModel.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final myDay = TimeOfDay.fromDateTime(DateTime.now());
    String greeting() {
      if (myDay.hour > 18) {
        return "Good Evening";
      } else if (myDay.hour > 12) {
        return "Good Afternoon";
      } else {
        return "Good Morning";
      }
    }

    _getInitial();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: _viewedRecipes(),
        appBar: AppBar(
          title: Text(
            greeting(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: backgroundColor,
          actions: [
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
        // Navigation bar
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }

  Column _viewedRecipes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // aligns to left of screen
      children: [
        searchField(),
        const SizedBox(
          height: 20,
        ), // distance from searchbar
        _recommended(),
        const SizedBox(
          height: 40,
        ), // distance from _recommended() section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              // formatting of text
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Recently viewed\nrecipes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
             
              height: 120,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: viewedRecipes[index].boxColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_card_rounded),
                        ),
                        Container(
                          alignment: const Alignment(0, 0),
                          child: Text(
                            // Uses the viewedRecipes to display data

                            '${viewedRecipes[index].name}\n${viewedRecipes[index].duration}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // space between items
                separatorBuilder: (context, index) => const SizedBox(
                  width: 20,
                ),
                // number of items in container
                itemCount: viewedRecipes.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Column _recommended() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
              left: 20), // specifies padding from left of screen
          child: Text(
            "Recommended",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold, // bolds font
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ), // distance from category text
        SizedBox(
          height: 150,
          child: ListView.separated(
            // allows scrolling  from left to right
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            separatorBuilder: (context, index) => const SizedBox(
              width: 25,
            ),
            // Length of category recommended
            itemCount: categories.length,
            itemBuilder: (context, index) {
              // index of images
              return Container(
                width: 150,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // contains placeholder image
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        // icon outer shape colour
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(

                          padding: const EdgeInsets.all(5.0),
                          child: IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.favorite_outline_outlined,
                                  ),
                                ),
                              ),

                    ),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: searchbarBackgroundColor.withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0)
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: searchbarBackgroundColor,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.search),
          ),
          hintText: "Search for recipes",
          hintStyle: const TextStyle(
            color: Color.fromARGB(122, 0, 0, 0),
            fontSize: 12,
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.filter_alt_rounded,size:30),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
 