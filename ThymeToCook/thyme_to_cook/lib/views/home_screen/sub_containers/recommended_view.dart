import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class RecommendedView extends StatefulWidget {

  const RecommendedView({super.key});

  @override
  State<RecommendedView> createState() => _RecommendedViewState();
}

class _RecommendedViewState extends State<RecommendedView> {
  late final RecipeStorage _recipeStorage;

  @override
  void initState() {
    _recipeStorage = RecipeStorage();
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
  // Checking purposes --> for when database goes down
  //   final List<String> recipeImages = [
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2Fdads-trinidadian-curried-chicken.jpg?alt=media&token=9ac64437-bb2b-4b10-9df5-d1db13c01081",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-bloody-mary-tomato-toast-with-celery-and-horseradish-56389813.jpg?alt=media&token=c7b2df2a-f9b2-4116-8d86-dec9a3eb6a4e",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-burnt-carrots-and-parsnips-56390131.jpg?alt=media&token=efa38af2-4c5a-485e-a26e-4cb2f5c51a43",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-candy-corn-frozen-citrus-cream-pops-368770.jpg?alt=media&token=dbfb9d14-1c32-4a59-a14e-c03a9da141b9",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-candy-corn-pumpkin-blondies-51254510.jpg?alt=media&token=d270e8d6-62ae-4530-9617-18246702b1b2",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-chickpea-barley-and-feta-salad-51239040.jpg?alt=media&token=3352a946-74e4-4b17-a743-faac83870190",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-em-ba-em-s-ultimate-lobster-rolls-51169080.jpg?alt=media&token=99ae6608-57f6-4dc2-be49-970982cca1d8",
  //   "https://firebasestorage.googleapis.com/v0/b/thymetocook-8d0f3.appspot.com/o/recipe_images%2F-em-gourmet-live-em-s-first-birthday-cake-367789.jpg?alt=media&token=04a02ab0-20fe-46d3-9c62-9cdb2c236d61"
  // ];
  var isLiked = false;
    return StreamBuilder(
      // Getting all recipes
      stream: _recipeStorage.getVeganRecipes(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            if (snapshot.hasData) {
            // if (true) {
              final allRecipes = snapshot.data as Iterable<CloudRecipe>;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allRecipes.length, 
                // itemCount: recipeImages.length,
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