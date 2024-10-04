import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class ViewedRecipeModel {
  String name;
  String iconPath;
  String duration;
  bool bViewIsSelected;
  Color boxColor;

  ViewedRecipeModel({
    
    required this.name,
    required this.iconPath,
    required this.duration,
    required this.bViewIsSelected,
    required this.boxColor,
  });

  static List <ViewedRecipeModel> getRecipes() {
    const color = recentlyViewedTileColor;
    List <ViewedRecipeModel> recipes = [];

    // placeholder logic
    recipes.add(
      ViewedRecipeModel(
        name: "Lasagna", 
        iconPath: 'assets/icon/placeholder_image.jpg', 
        duration: '120 min',
         
        bViewIsSelected: true,
       boxColor: color,
      )
    );

    recipes.add(
      ViewedRecipeModel(
        name: "----", 
        iconPath: 'assets/icon/placeholder_image.jpg', 
        duration: '30 min', 
        bViewIsSelected: true,
        boxColor: color,
      )
    );

    recipes.add(
      ViewedRecipeModel(
        name: "----", 
        iconPath: 'assets/icon/placeholder_image.jpg', 
        duration: '30 min', 
        bViewIsSelected: true
        ,boxColor: color,
      )
    );
    return recipes;
  }

}