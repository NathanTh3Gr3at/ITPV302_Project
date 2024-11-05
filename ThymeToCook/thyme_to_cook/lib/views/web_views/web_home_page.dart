import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> with TickerProviderStateMixin {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic here
        },
        child: SingleChildScrollView(
          controller: exploreController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 16),
                  child: Text(
                    "Explore Recipes",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2, // Adjust column count based on screen width
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4, // Adjust for image size balance
                  ),
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    final imageUrl = recipe.imageSrc ?? "recipe.imageUrl" ?? "";
                    log("Loading image: $recipe.imageUrl");
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponsiveWrapper.builder(
                              RecipeView(recipe: recipe),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        child: Stack(
                          children: [
                            Image.network(
                              recipe.imageUrl ?? recipe.imageSrc ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  child: const Center(child: Text('Image not found')),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  recipe.recipeName,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: Icon(MdiIcons.heartOutline, color: const Color.fromARGB(255, 153, 142, 160)),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 162, 206, 100),
        shape: const CircleBorder(),
        elevation: 20,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
