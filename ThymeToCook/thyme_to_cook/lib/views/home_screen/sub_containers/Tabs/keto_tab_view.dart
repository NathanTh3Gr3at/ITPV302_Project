import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class KetoTabView extends StatefulWidget {

  const KetoTabView({super.key});

  @override
  State<KetoTabView> createState() => _KetoTabViewState();
}

class _KetoTabViewState extends State<KetoTabView> {
  late final RecipeStorage _recipeStorage;

  @override
  void initState() {
    _recipeStorage = RecipeStorage();
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
  var isLiked = false;
    return StreamBuilder(
      // Getting vegan recipes
      stream: _recipeStorage.getKetoRecipes(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allRecipes = snapshot.data as Iterable<CloudRecipe>;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allRecipes.length, 
                itemBuilder: (context, index) {
                  final recipe = allRecipes.elementAt(index);
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
                        InkWell(
                          onTap: () {
                            log("Tapped");
                          },
                          child: Stack(
                            children: [
                            Image.network(
                                  recipe.imageSrc ?? "",
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