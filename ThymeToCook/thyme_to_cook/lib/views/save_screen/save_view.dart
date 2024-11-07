import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
=======
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/helpers/saving_recipes/heart_icon.dart';
import 'package:thyme_to_cook/models/recipe_model.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
>>>>>>> 6c60a5a (Updated save feature)
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
            height: 450,
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

                 return Card(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResponsiveWrapper.builder(
                                                  RecipeView(recipe: recipe),
                                                  breakpoints: const [
                                                    ResponsiveBreakpoint.resize(
                                                        480,
                                                        name: MOBILE),
                                                    ResponsiveBreakpoint.resize(
                                                        800,
                                                        name: TABLET),
                                                    ResponsiveBreakpoint
                                                        .autoScale(1000,
                                                            name: DESKTOP),
                                                    ResponsiveBreakpoint
                                                        .autoScale(2460,
                                                            name: '4K'),
                                                  ],
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        recipe.imageSrc ??
                                            recipe.imageUrl ??
                                            "",
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey,
                                            child: const Center(
                                              child: Text('Image not found'),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 350,
                                          color: Colors.black.withOpacity(0.3),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              recipe.recipeName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Like button
                                      Positioned(
                                        top: 8,
                                        right: 3,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          padding: const EdgeInsets.all(
                                              0), // Adjusted padding
                                              child: BlocBuilder<SaveRecipeCubit, List<CloudRecipe>>(
                                                builder: (context, likedRecipes) {
                                                  return HeartIconButton(
                                                    recipeId: recipe.recipeId, 
                                                    recipe: recipe);
                                                }
                                              
                                              ),
                                          // child: BlocBuilder<SaveRecipeCubit, List<CloudRecipe>>(
                                          // builder: (context, likedRecipes) {
                                          //   final isLiked = likedRecipes.any((liked) => liked.recipeId == recipe.recipeId);
                                          //   return IconButton(
                                          //   onPressed: () {
                                          //     // setState(() {
                                          //       final saveRecipe = context
                                          //           .read<SaveRecipeCubit>();

                                          //       if(isLiked) {
                                          //         saveRecipe.unlike(recipe.recipeId);
                                          //       }
                                          //       else {
                                          //         saveRecipe.likeRecipe(recipe);
                                          //       }
                                          //   },
                                          //   icon: Icon(
                                          //     isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
                                          //     color: isLiked ? Colors.red :Colors.grey 
                                          //   ),
                                          // );
                                        // }
                                        ),
                                      ),
                                     
                                    ],
                                  ),
                                ),
                              ],
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
