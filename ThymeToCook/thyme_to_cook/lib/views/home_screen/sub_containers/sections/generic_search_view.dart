import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_state.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class GenericSearchView extends StatefulWidget {
  final String cuisine;
  const GenericSearchView({super.key, required this.cuisine});

  @override
  State<GenericSearchView> createState() => _GenericSearchViewState();
}

class _GenericSearchViewState extends State<GenericSearchView> {
  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  late TextEditingController _searchController;
  Set<String> selectedFilter = {};
  RecipeStorage? _recipeStorage;
  List<String>? selectedMealTypes;
  DocumentSnapshot? lastDocument;
  late SearchBloc searchBloc;
  bool showClearTextButton = false;
  int pageIndex = 0;

 void onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchMoreRecipes();
    }
  }

  // Method to fetch recipes --> if the user changes the search this will be triggered and fetch new recipes
void fetchMoreRecipes({int pageIndex = 0}) {
  if (_recipeStorage != null) {

    _recipeStorage!.fetchRecipes(
      limit: pageSize,
      pageIndex: pageIndex,
      mealTypes: [widget.cuisine.toString()],
    ).then((recipes) {
      log("Fetched recipes count: ${recipes.length}");
      setState(() {
        if (recipes.isNotEmpty) {
          _recipeStorage!.cacheRecipes(recipes);
        }
        searchBloc.add(SearchWithFilters(
          searchText: "",
          mealTypes: [widget.cuisine.toString()],
        ));
      });
    });
  }
}

  @override
  void initState() {
    super.initState();
    _recipeStorage = Provider.of<RecipeStorage>(context, listen: false);
    searchBloc = SearchBloc(_recipeStorage!);
    scrollController.addListener(onScroll);
    fetchMoreRecipes(); // Initial fetch
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchBloc,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 0,
          title: Text(widget.cuisine.toString()),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              MdiIcons.chevronLeft,
            ),
            iconSize: 35,
            ),
            leadingWidth: 40,
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchError) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            } else if (state is SearchSuccess) {
              final recipes = state.recipes;
              if (recipes.isEmpty) {
                return const Center(
                  child: Text("No recipes found")
                );
              }
                return Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          CloudRecipe recipe = recipes[index];
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
                                        top: 14,
                                        right: 20,
                                        child: Text(
                                          recipe.rating!,
                                          style: const TextStyle(
                                            color: Colors.white
                                          ),
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
                    );
            } else {
              return const Center(
                child: Text("No recipes found")
              );
            }
          },
        ),
      ));
  }
}
 