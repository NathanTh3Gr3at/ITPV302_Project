import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class GlutenFreeTabView extends StatefulWidget {

  const GlutenFreeTabView({super.key});

  @override
  State<GlutenFreeTabView> createState() => _GlutenFreeTabViewState();
}

class _GlutenFreeTabViewState extends State<GlutenFreeTabView> {
  @override
  Widget build(BuildContext context) {
  final recipeStorage = Provider.of<RecipeStorage>(context);
  var isLiked = false;
  int limit = 10;
    return StreamBuilder(
      // Getting vegan recipes
      stream: recipeStorage.getCachedRecipesStream(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allRecipes = snapshot.data as Iterable<CloudRecipe>;
              if (allRecipes.isEmpty) {
                return const Center(child: Text("No Recipes available"));
              }
              // Limiting the number of recipes shown to the user 
              final displayRecipes = allRecipes.take(limit).toList();
              return ListView.builder(
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
                                builder: (context) => ResponsiveWrapper.builder(
                                  RecipeView(recipe: recipe),
                                  breakpoints: const [
                                  ResponsiveBreakpoint.resize(480, name: MOBILE),
                                  ResponsiveBreakpoint.resize(800, name: TABLET),
                                  ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                  ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                                  ],
                            )
                            )
                          );
                        },
                          child: Stack(
                            children: [
                            Image.network(
                                  imageUrl ?? "",
                                  // recipeImages[index],
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
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 0.1, horizontal: 0.1),
                        child: IconButton(
                          onPressed: () {
                            log(isLiked.toString());
                          },
                          icon: Icon(
                            MdiIcons.heartOutline,
                            color: const Color.fromARGB(255, 153, 142, 160),
                          ) ,
                        ),
                      ),
                    ),
                            ]
                          ),
                        ),
                        ]
                      ),
                    ),
                  );
                },
              );
             }  //else {
              return const Center(child: Text("No recipes available"));  
          default:
            return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}