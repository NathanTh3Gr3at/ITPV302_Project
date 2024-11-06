//CLOUD RECIPE



import 'package:thyme_to_cook/services/sqlite_db/db_recipe_ingredient.dart';

class DbRecipe {
  final String recipeId;
  final String recipeName;
  final String? cookingTime;
  final DateTime createDate;
  final DateTime updateDate;
  final int? calories;
  final String? imageSrc;
  final String? recipeDescription;
  final int? recipeServings;
  final List<String>? cuisinePath;
  final String? identifier;
  final String? prepTime;
  final String? rating;
  final String? totalTime;
  final List<DbRecipeIngredient> recipeIngredients;
  DbRecipe({
    required this.recipeId,
    required this.recipeName,
    required this.createDate,
    required this.updateDate,
    this.cookingTime,
    this.calories,
    this.imageSrc,
    this.recipeDescription,
    this.recipeServings,
    this.cuisinePath,
    this.identifier,
    this.prepTime,
    this.rating,
    this.totalTime,
    this.recipeIngredients = const [],
  });
  //converts to SQLite map
  Map<String,dynamic>toMap(){
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'cookingTime': cookingTime,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
      'calories': calories,
      'imageSrc': imageSrc,
      'recipeDescription': recipeDescription,
      'recipeServings': recipeServings,
      'cuisinePath': cuisinePath?.join(','), // Join as comma-separated for SQLite
      'identifier': identifier,
      'prepTime': prepTime,
      'rating': rating,
      'totalTime': totalTime,
    };
  }
  // Converts from SQLite map
  static DbRecipe fromMap(Map<String,dynamic>map,List<DbRecipeIngredient>ingredients){
    return DbRecipe(
      recipeId: map['recipeId'],
      recipeName: map['recipeName'],
      cookingTime: map['cookingTime'],
      createDate: DateTime.parse(map['createDate']),
      updateDate: DateTime.parse(map['updateDate']),
      calories: map['calories'],
      imageSrc: map['imageSrc'],
      recipeDescription: map['recipeDescription'],
      recipeServings: map['recipeServings'],
      cuisinePath: map['cuisinePath']?.split(','), // Split from comma-separated
      identifier: map['identifier'],
      prepTime: map['prepTime'],
      rating: map['rating'],
      totalTime: map['totalTime'],
      recipeIngredients: ingredients,
    );
  }
}