import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/models/recipe_model.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class SaveView extends StatefulWidget {
  const SaveView({super.key});

  @override
  State<SaveView> createState() => _SaveViewState();
}

class _SaveViewState extends State<SaveView> {
  List<CloudRecipe> recipes = [];
  Set<String> selectedFilter = {};
  // late SaveRecipeCubit saveRecipeCubit;

  // void _getRecipes() {
  //   recipes = RecipeModel.getRecipe();
  // }

  @override
  void initState() {
    super.initState();
    // _getRecipes();
    // initializes the save_cubit
    // saveRecipeCubit = SaveRecipeCubit();
  }

  @override
  Widget build(BuildContext context) {
    // _getInitial();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        body: Column(
          children: [
            // _searchField(),
            const SizedBox(
              height: 5,
            ),
            _filterTabs(),
            const SizedBox(
              height: 5,
            ),
            // using cubit to fill tiles
            Expanded(
              child: BlocBuilder<SaveRecipeCubit, List<CloudRecipe>>(
                  builder: (context, likedRecipes) {
                if (likedRecipes.isEmpty) {
                  return const Center(
                      child: Text(
                    "No recipes saved yet",
                    style: TextStyle(fontSize: 20),
                  ));
                } 
                // else {
                  // return ListView.builder(
                  //      itemCount: likedRecipes.length,
                  //      itemBuilder: (context, index) {
                  return _likedRecipes(likedRecipes);
                // }
              }),
            )
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      title: const Text(
        "Saved Recipes",
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Column _likedRecipes(List<CloudRecipe> likedRecipes) {
    return Column(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Padding(
          //   padding: EdgeInsets.only(left: 10, bottom: 20),
          //   child: Text(
          //     "Recipes",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 20,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          SizedBox(
            height: 350,
            // width: 400,
            child: GridView.builder(
              //  padding: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10, // spacing between grid
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 1.5,
              ),

              itemCount: likedRecipes.length,
              itemBuilder: (context, index) {
                CloudRecipe recipe = likedRecipes[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => RecipeView(recipe: recipe)));
                    // setState(() {});
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      // colour or image of tile
                      color:
                          //   recipes[index].liked
                          // ? const Color.fromARGB(255, 240, 240, 240)
                          const Color.fromARGB(255, 240, 240, 240),
                      border: Border.all(
                        color: const Color.fromARGB(255, 232, 232, 232),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(235, 217, 217, 217)
                              .withOpacity(0.5),
                          offset: const Offset(0, 9),
                          blurRadius: 20,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Column(
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Heart Icon

                              IconButton(
                                onPressed: () {
                                  // unliking recipe
                                  context
                                      .read<SaveRecipeCubit>()
                                      .unlike(recipe.recipeId);

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("${recipe.recipeName} was removed from your saved list" ),
                                    // must be tested
                                    duration: const Duration(seconds: 3),
                                    action: SnackBarAction(
                                      label: 'Undo', 
                                      onPressed: () {
                                        context.read<SaveRecipeCubit>().likeRecipe(recipe);
                                        },
                                      ),

                                    ),
                                  );

                                  // recipes[index].liked =
                                  //     !recipes[index].liked;
                                },
                                // icon: Icon(recipes[index].liked
                                //     ? Icons.keyboard_control
                                //     : Icons.keyboard_control),
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  recipe.recipeName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 20),
                                ),
                                
                              
                                // Text(
                                //   '${recipe.recipeDescription}',
                                //   style: const TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w300),
                                // ),
                              ],
                            ),
                          ),

                          // positioning of image (must still fix displaying of images)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          //  child: 
                          //  Image.network(recipe.imageSrc ?? recipe.imageUrl ?? "",
                          //   width: 100,
                          //   height: 100,
                          //  )
                            // recipe image
                            // child: Image.asset(
                            //   recipe[index].iconPath,
                            //   width: 100,
                            //   height: 100,
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    ]);
  }

  // Container _searchField() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //             color: const Color.fromARGB(255, 246, 235, 235).withOpacity(0.11),
  //             blurRadius: 40,
  //             spreadRadius: 0.0)
  //       ],
  //     ),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         filled: true,
  //         fillColor: searchbarBackgroundColor,
  //         contentPadding: const EdgeInsets.all(15),
  //         prefixIcon: const Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Icon(Icons.search),
  //         ),
  //         hintText: "Search Saved Recipes",
  //         hintStyle: const TextStyle(
  //           color: Color.fromARGB(122, 0, 0, 0),
  //           fontSize: 12,
  //         ),
  //         suffixIcon: const Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Icon(Icons.filter_alt_rounded),
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(15),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }

// filter section
  Column _filterTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 5,
            bottom: 20,
          ),
          child: Text(
            "Recipe Collection",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SingleChildScrollView(
          // wraps filter row for scrolling
          scrollDirection: Axis.horizontal,
          child: Row(children: <Widget>[
            filterRow('All Recipes'),
            filterRow('Recently Viewed'),
            filterRow('Nutrition'),
            filterRow('Duration'),
          ]),
        ),
      ],
    );
  }

  Widget filterRow(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 15, bottom: 5),
      child: InputChip(
        elevation: 5,
        label: Text(label),
        backgroundColor: Colors.white,
        avatar: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 204, 204, 204),
        ),
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
