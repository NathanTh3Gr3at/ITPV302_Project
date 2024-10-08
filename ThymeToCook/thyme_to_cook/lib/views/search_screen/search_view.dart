import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thyme_to_cook/models/recipe_model.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<RecipeModel> recipes = [];
  Set<String> selectedFilter = {};

  void _getRecipes() {
    recipes = RecipeModel.getRecipe();
  }

  @override
  void initState() {
    super.initState();
    _getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    // _getInitial();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: ListView(
        children: [
          _searchRecipes(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      title: const Text(
        "Search",
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Column _searchRecipes() {
    return Column(children: [
      const SizedBox(
        height: 2,
      ),
      _searchField(),
      const SizedBox(
        height: 5,
      ),
      _filterTabs(),
      const SizedBox(
        height: 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 20),
            child: Text(
              "Recipes you might like",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // const SizedBox(height: 10,
          // ),
          SizedBox(
            height: 350,
            child: ListView.separated(
              shrinkWrap: true, // wraps list content

              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      // selecting to go to recipe screens would go here
                    });
                  },
                  child: Container(
                    height: 115,
                    decoration: BoxDecoration(
                      color: recipes[index].liked
                          ? const Color.fromARGB(255, 240, 240, 240)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 232, 232, 232),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: recipes[index].liked
                          ? [
                              BoxShadow(
                                color: const Color.fromARGB(235, 217, 217, 217)
                                    .withOpacity(0.5),
                                offset: const Offset(0, 9),
                                blurRadius: 20,
                                spreadRadius: 0,
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // recipe image
                        Image.asset(
                          recipes[index].iconPath,
                          width: 100,
                          height: 100,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipes[index].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            Text(
                              '${recipes[index].nutrition} ${recipes[index].duration}  ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        // Heart Icon
                        IconButton(
                          onPressed: () {
                            setState(
                              () {
                                recipes[index].liked = !recipes[index].liked;
                              },
                            );
                          },
                          icon: Icon(
                            recipes[index].liked
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color:
                                recipes[index].liked ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
              padding: const EdgeInsets.only(left: 10, right: 10),
              itemCount: recipes.length,
            ),
          ),
        ],
      )
    ]);
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 246, 235, 235).withOpacity(0.11),
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
            child: Icon(Icons.filter_alt_rounded),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

// filter section
  Column _filterTabs() {
    return Column(
      children: [
        SingleChildScrollView(
          // wraps filter row for scrolling
          scrollDirection: Axis.horizontal,
          child: Row(children: <Widget>[
            filterRow('Diet'),
            filterRow('Ingredients'),
            filterRow('Nutrition'),
            filterRow('Duration'),
          ]),
        ),
      ],
    );
  }

  Widget filterRow(String label) {
    // bool bIsSelected;
    // bIsSelected = false;
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: InputChip(
        label: Text(label),
        backgroundColor: miniTileColor,
        padding: const EdgeInsets.all(2),
        selected: selectedFilter.contains(label),
        selectedColor: const Color.fromARGB(255, 226, 226, 226),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              selectedFilter.add(label);
            } else {
              selectedFilter.remove(label);
            }
          });
        },
      ),
    );
  }
}
