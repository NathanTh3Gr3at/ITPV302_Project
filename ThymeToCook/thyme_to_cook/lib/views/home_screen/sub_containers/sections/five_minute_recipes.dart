import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/helpers/saving_recipes/heart_icon.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class FifteenMinuteRecipesView extends StatefulWidget {
  const FifteenMinuteRecipesView({super.key});

  @override
  State<FifteenMinuteRecipesView> createState() =>
      _FifteenMinuteRecipesViewState();
}

class _FifteenMinuteRecipesViewState extends State<FifteenMinuteRecipesView> {
  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  Set<String> selectedFilter = {};
  RecipeStorage? _recipeStorage;
  List<String>? selectedMealTypes;
  bool showClearTextButton = false;
  int pageIndex = 0;
  late SearchBloc searchBloc;
  List<CloudRecipe> _recipes = [];

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      fetchMoreRecipes();
    }
  }

  // Method to fetch recipes --> if the user changes the search this will be triggered and fetch new recipes
  void fetchMoreRecipes({int pageIndex = 0}) {
    if (_recipeStorage != null) {
      _recipeStorage!.fetchRecipes(
        limit: pageSize,
        pageIndex: pageIndex,
        totalTimes: ["30 mins"],
      ).then((recipes) {
        log("Fetched recipes count: ${recipes.length}");
        setState(() {
          _recipes.addAll(recipes);
          searchBloc.add(const SearchWithFilters(
            searchText: "",
            totalTimes: ["30 mins"],
          ));
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMoreRecipes();
    _recipeStorage = Provider.of<RecipeStorage>(context, listen: false);
    searchBloc = SearchBloc(_recipeStorage!);
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeStorage = Provider.of<RecipeStorage>(context);
    var isLiked = false;
    int limit = 15;

    return StreamBuilder(
      stream: recipeStorage.getCachedRecipesStream(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            if (_recipes.isEmpty) {
              return const Center(child: Text("No Recipes available"));
            }
            // Limiting the number of recipes shown to the user
            final displayRecipes = _recipes.take(limit).toList();
            return ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: displayRecipes.length,
              itemBuilder: (context, index) {
                final recipe = displayRecipes[index];
                String? imageUrl;
                if (recipe.identifier == "kaggle") {
                  imageUrl = recipe.imageSrc;
                } else {
                  imageUrl = recipe.imageUrl;
                }
                return SizedBox(
                  height: double.infinity,
                  width: 210,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    borderOnForeground: true,
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
                                            ResponsiveBreakpoint.resize(480,
                                                name: MOBILE),
                                            ResponsiveBreakpoint.resize(800,
                                                name: TABLET),
                                            ResponsiveBreakpoint.autoScale(1000,
                                                name: DESKTOP),
                                            ResponsiveBreakpoint.autoScale(2460,
                                                name: '4K'),
                                          ],
                                        )));
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                imageUrl ?? "",
                                fit: BoxFit.cover,
                                height: 265,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: const Center(
                                        child: Text('Image not found')),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 280,
                                  color: Colors.black.withOpacity(0.1),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      recipe.recipeName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.1, horizontal: 0.1),
                                  child: HeartIconButton(
                                    recipeId: recipe.recipeId,
                                    recipe: recipe,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
