import 'package:flutter/material.dart';

@immutable
class CloudRecipe {
  final int cookingTime;
  final DateTime createDate;
  final String imageUrl;
  final Map<String, dynamic> tags;
  final String recipeDescription;
  final List<String> recipeIngredients;
  final List<String> recipeInstructions;
  final String recipeName;
  final int recipeServings;
  final DateTime updateDate;

  const CloudRecipe(
    this.cookingTime, 
    this.createDate, 
    this.imageUrl, 
    this.tags, 
    this.recipeDescription, 
    this.recipeIngredients, 
    this.recipeInstructions, 
    this.recipeName, 
    this.recipeServings, 
    this.updateDate);
  
}