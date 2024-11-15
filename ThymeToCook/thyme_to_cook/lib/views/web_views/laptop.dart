import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class LaptopHomePageView extends StatefulWidget {
  const LaptopHomePageView({super.key});

  @override
  State<LaptopHomePageView> createState() => _LaptopHomePageViewState();
}

class _LaptopHomePageViewState extends State<LaptopHomePageView> {
   bool isOffline = false;
  final ScrollController exploreController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  RecipeStorage? _recipeStorage;
  List<CloudRecipe> _recipes = [];
  late SearchBloc searchBloc;

  void onScroll() {
    if (exploreController.position.pixels == exploreController.position.maxScrollExtent) {
      fetchMoreRecipes();
    }
  }

  void fetch30Recipes({int pageIndex = 0}) {
    _recipeStorage?.fetchRecipes(limit: pageSize, pageIndex: pageIndex, totalTimes: ["30 mins"]).then((recipes) {
      setState(() {
        _recipes.addAll(recipes);
        searchBloc.add(const SearchWithFilters(searchText: "", totalTimes: ["30 mins"]));
      });
    });
  }

  void fetchMoreRecipes({int pageIndex = 0}) {
    _recipeStorage?.fetchRecipes(pageIndex: pageIndex).then((recipes) {
      setState(() {
        _recipes.addAll(recipes);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _recipeStorage = Provider.of<RecipeStorage>(context, listen: false);
    searchBloc = SearchBloc(_recipeStorage!);
    exploreController.addListener(onScroll);
    fetch30Recipes();
    fetchMoreRecipes();
  }

  @override
  void dispose() {
    exploreController.dispose();
    super.dispose();
  } // Add recipes data here

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth > 1200 ? 100 : 20),
          child: Column(
            children: [
              const SizedBox(height: 50), // Add spacing from the top
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Explore Recipes",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: _recipes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Four columns for laptop screens
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4, // Adjust for optimal card size
                  ),
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    final imageUrl = recipe.imageSrc;

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
                                  builder: (context) => RecipeView(recipe: recipe),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    imageUrl ?? "",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        child: const Center(child: Text('Image not found')),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.black.withOpacity(0.6),
                                  child: Text(
                                    recipe.recipeName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {
                                // Handle like functionality
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
