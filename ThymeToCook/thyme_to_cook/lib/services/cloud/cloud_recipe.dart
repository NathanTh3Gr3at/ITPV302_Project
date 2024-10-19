import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class CloudRecipe {
  final int calories;
  final int cookingTime;
  final DateTime createDate;
  final String imageUrl;
  final List<String> nutritionalInfo;
  final String recipeDescription;
  final List<String> recipeIngredients;
  final List<String> recipeInstructions;
  final String recipeName;
  final String recipeServings;
  final Map<String, List<String>> tags;
  // final String tags;
  final DateTime updateDate;

  // final bool liked;

  const CloudRecipe({
    required this.calories,
    required this.cookingTime,
    required this.createDate,
    required this.imageUrl,
    required this.nutritionalInfo,
    required this.recipeDescription,
    required this.recipeIngredients,
    required this.recipeInstructions,
    required this.recipeName,
    required this.recipeServings,
    required this.tags,
    required this.updateDate,
    // this.liked = false,
  });

  // const CloudRecipe(
  //     this.cookingTime,
  //     this.createDate,
  //     this.imageUrl,
  //     this.tags,
  //     this.recipeDescription,
  //     this.recipeIngredients,
  //     this.recipeInstructions,
  //     this.recipeName,
  //     this.recipeServings,
  //     this.updateDate);

  // for saving data to the firestore
  // Map<String, dynamic> toJson() {
  //   return {
  //     // 'calories': calories,
  //     'cooking_time': cookingTime,
  //     'create_date': createDate,
  //     'image_url': imageUrl,
  //     // 'nutritional_info': nutritionalInfo,
  //     'recipe_description': recipeDescription,
  //     'recipe_ingredients': recipeIngredients,
  //     'recipe_instructions': recipeInstructions,
  //     'recipe_name': recipeName,
  //     'recipe_servings': recipeServings,
  //     'tags': tags,
  //     'update_date': updateDate,
  //   };
  // }

  // converting json to cloud recipe for pulling data
  factory CloudRecipe.fromJson(Map<String, dynamic> json) {
    // print(json);    // for debugging
    try {
      return CloudRecipe(
        calories: json['calories'] ?? 0,
        cookingTime: json['cooking_time'] ?? 0,
        createDate: (json['create_date'] as Timestamp).toDate(),
        imageUrl: json['image_url'] ?? '',
        nutritionalInfo: List<String>.from(json['nutritional_info'] ?? []),
        recipeDescription: json['recipe_description'] ?? '',
        // converts into a list of strings, then uses maps each ingredient name to a list
        recipeIngredients: List<String>.from(
            json['recipe_ingredients']?.map((e) => e['ingredient_name']) ?? []),
        recipeInstructions: List<String>.from(
            json['recipe_instructions']?.map((e) => e['instruction']) ?? []),
        recipeName: json['recipe_name'] ?? '',
        recipeServings: json['recipe_servings'] ?? '',

        // converts tags map to key type of string with value string
        tags: (json['tags'] is Map) // checks if tag is a map field
            // if tag is a map then convert key to string and value to List<string>
            ? (json['tags'] as Map<String, dynamic>)
                .map<String, List<String>>((key, value) {
                return MapEntry(key, List<String>.from(value as List<dynamic>));
              })
            : <String, List<String>>{},

        updateDate: (json['update_date'] as Timestamp).toDate(),
      );
    } catch (e) {
      print("Error getting CloudRecipe: $e");
      throw Exception("Error parsing CloudRecipe: $e");
    }
  }
}
