import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';

class SaveView extends StatefulWidget {
  const SaveView({super.key});

  @override
  State<SaveView> createState() => _SaveViewState();
}

class _SaveViewState extends State<SaveView> {
  List<CloudRecipe> recipes = [];
  Set<String> selectedFilter = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: appBar(),
        body: Column(

          children: [
            // using cubit to fill tiles
            Expanded(
              // Use Expanded here to take remaining space
              child: BlocBuilder<SaveRecipeCubit, List<CloudRecipe>>(
                builder: (context, likedRecipes) {
                  if (likedRecipes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/images/sad_image.png'),
                            height: 200, // Adjust height as needed
                          ),
                          const SizedBox(height: 20),
                          Card(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "You have no saved recipes, Search for recipes to add",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ResponsiveWrapper.builder(
                                            const AdjustedSearchView(),
                                            breakpoints: const [
                                              ResponsiveBreakpoint.resize(480,
                                                  name: MOBILE),
                                              ResponsiveBreakpoint.resize(800,
                                                  name: TABLET),
                                              ResponsiveBreakpoint.autoScale(
                                                  1000,
                                                  name: DESKTOP),
                                              ResponsiveBreakpoint.autoScale(
                                                  2460,
                                                  name: '4K'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Search for recipes'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return _likedRecipes(likedRecipes);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 /*  AppBar appBar() {
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
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: _filterTabs(),
      // ),
    );
  } */

  Widget _likedRecipes(List<CloudRecipe> likedRecipes) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1.5,
      ),

      itemCount: likedRecipes.length,
      itemBuilder: (context, index) {
        CloudRecipe recipe = likedRecipes[index];
        String imageUrl =
            recipe.identifier == "kaggle" ? recipe.imageSrc! : recipe.imageUrl!;
        return Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeView(recipe: recipe),
                      ));
                },
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              IconButton(
                                onPressed: () {
                                  context
                                      .read<SaveRecipeCubit>()
                                      .unlike(recipe.recipeId);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "${recipe.recipeName} was removed from your saved list"),
                                    duration: const Duration(seconds: 3),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        context
                                            .read<SaveRecipeCubit>()
                                            .likeRecipe(recipe);
                                      },
                                    ),
                                  ));
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// filter section
  Column _filterTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        SingleChildScrollView(
          // wraps filter row for scrolling
          scrollDirection: Axis.horizontal,
          child: Row(children: <Widget>[
            filterRow('All Saved Recipes'),
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
        selectedColor: const Color.fromARGB(255, 123, 175, 116),
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
