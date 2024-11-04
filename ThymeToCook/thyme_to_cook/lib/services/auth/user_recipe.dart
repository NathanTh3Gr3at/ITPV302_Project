
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:fraction/fraction.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_storage_constants.dart';

class RecipeIngredient {
  final String? ingredientName;
  final double? quantity;
  final String? unit;

  RecipeIngredient({
    required this.ingredientName,
    required this.quantity,
    required this.unit,
  });
  // Mapping data from the database to the our class model 
  // Conerting our string values from the database to doubles so we can perform calculations on them
  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    double? quantity;

    try {
      quantity = Fraction.fromString(map["quantity"] as String).toDouble();
      // log(quantity.toString());
    } catch (e) {
      quantity = 1.0; 
      // log(quantity.toString());
    }
    return RecipeIngredient(
      ingredientName: map["ingredient_name"] as String?,
      quantity: quantity,
      unit: map["unit"] as String?,
    );
  }
 // Mapping a the quantity field in firebase to the our data to then be sent to firebase
  Map<String, dynamic> toMap() {
    return {
      "ingredient_name": ingredientName,
      "quantity": quantity?.toString(),
      "unit": unit
    };
  }
  // No complex fractions
String simplifyFraction(Decimal number) {
  Decimal threshold = Decimal.parse('0.1');
  Decimal threeQuarters = Decimal.parse('0.75');
  Decimal half = Decimal.parse('0.5');
  Decimal oneThird = Decimal.parse('0.3333');
  Decimal quarter = Decimal.parse('0.25');

  if ((number - Decimal.one).abs() < threshold) {
    return '1';
  } else if ((number - threeQuarters).abs() < threshold) {
    return '3/4';
  } else if ((number - half).abs() < threshold) {
    return '1/2';
  } else if ((number - oneThird).abs() < threshold) {
    return '1/3';
  } else if ((number - quarter).abs() < threshold) {
    return '1/4';
  }
  // If it doesn't fit well, just rounding it to the nearest whole number or fraction
  return number.round().toString();
}
// Method to get convert our values back to readable fractions so our numbers have a consistent feel and we have a more user-centric design
String getQuantityAsFraction() {
  if (quantity == 0) {
    return '1';
  } else if (quantity != null) {
    Decimal quantityDecimal = Decimal.parse(quantity!.toString());
    return simplifyFraction(quantityDecimal);
  }
  return '';
}
}

class RecipeInstructions {
  String? instruction;
  int? time;
  String? unit;

  RecipeInstructions({
    required this.instruction,
    required this.time,
    required this.unit,
  });
 // Mapping data from the database to the our class model 
  factory RecipeInstructions.fromMap(Map<String, dynamic> map) {
    return RecipeInstructions(
      instruction: map["instruction"] as String?,
      time: map["time"] as int?,
      unit: map["unit"] as String?,
    );
  }
  // Method to get convert our values back to human readable fractions so our numbers have a consistent feel and we have a more user-centric design
  Map<String, dynamic> toMap() {
    return {
      "instruction": instruction,
      "time": time,
      "unit": unit
    };
  }
}
class UserRecipe {
  String recipeId;
  String? cookingTime;
  DateTime createDate;
  int? calories;
  // For the jpg not the actual url
  String? imageSrc;
  Map<String, dynamic> tags;
  String? recipeDescription;
  List<RecipeIngredient> recipeIngredients;
  List<RecipeInstructions> recipeInstructions;
  List<String> nutritionalInfo;
  String recipeName;
  int? recipeServings;
  DateTime updateDate;
  List<String>? cuisinePath;
  String? imageUrl;
  String? identifier;
  String? prepTime;
  String? rating;
  String? totalTime; 
  
  DocumentSnapshot<Map<String, dynamic>>? docSnapshot;

  UserRecipe({
    required this.recipeId,
    required this.cookingTime, 
    required this.createDate, 
    required this.imageSrc, 
    required this.tags, 
    required this.recipeDescription, 
    required this.recipeIngredients, 
    required this.recipeInstructions, 
    required this.recipeName, 
    required this.recipeServings, 
    required this.updateDate, 
    required this.calories, 
    required this.nutritionalInfo, 
    required this.cuisinePath, 
    required this.imageUrl, 
    required this.identifier, 
    required this.prepTime, 
    required this.rating, 
    required this.totalTime, 
    this.docSnapshot,
});

  factory UserRecipe.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
  {
  var data = snapshot.data();
  // log('Snapshot data: $data');
  try {
    List<RecipeIngredient> ingredients = [];
    if (data[recipeIngredientsFieldName] is List) {
      ingredients = (data[recipeIngredientsFieldName] as List)
          .map((ingredient) => RecipeIngredient.fromMap(ingredient as Map<String, dynamic>))
          .toList();
    }

    List<RecipeInstructions> instructions = [];
    if (data[recipeInstructionsFieldName] is List) {
      instructions = (data[recipeInstructionsFieldName] as List)
          .map((instruction) => RecipeInstructions.fromMap(instruction as Map<String, dynamic>))
          .toList();
    }

    List<String> nutritionalInfo = [];
    var nutritionalInfoField = data[nutritionalInfoFieldName];
    if (nutritionalInfoField is List) {
      nutritionalInfo = List<String>.from(nutritionalInfoField);
    } else if (nutritionalInfoField is String) {
      nutritionalInfo = [nutritionalInfoField];
    }

    int? calories;
    var caloriesField = data[caloriesFieldName];
    if (caloriesField is int) {
      calories = caloriesField;
    } else if (caloriesField is double) {
      calories = caloriesField.toInt();
    } else {
      calories = null; 
    }

    List<String> cuisinePath = [];
    var cuisinePathField = data[cuisinePathFieldName];
    if (cuisinePathField is List) {
      cuisinePath = List<String>.from(cuisinePathField);
    } else if (cuisinePathField is String) {
      cuisinePath = [cuisinePathField];
    }

    return UserRecipe(
      recipeId: snapshot.id,
      cookingTime: data[cookingTimeFieldName]?.toString(),
      createDate: (data[createDateFieldName] as Timestamp).toDate(),
      calories: calories,
      imageSrc: data[imageSrcFieldName] as String? ?? "",
      tags: Map<String, dynamic>.from(data[tagsFieldName] as Map? ?? {}),
      recipeDescription: data[recipeDescriptionFieldName] as String? ?? "",
      recipeIngredients: ingredients,
      recipeInstructions: instructions,
      nutritionalInfo: nutritionalInfo,
      recipeName: data[recipeNameFieldName] as String? ?? "",
      recipeServings: int.tryParse(data[recipeServingsFieldName]?.toString() ?? "1") ?? 1,
      updateDate: (data[updateDateFieldName] as Timestamp).toDate(),
      cuisinePath: cuisinePath,
      imageUrl: data[imageUrlFieldName] as String? ?? "",
      identifier: data[identifierFieldName] as String? ?? "",
      prepTime: data[prepTimeFieldName] as String? ?? "",
      rating: data[ratingFieldName] as String? ?? "",
      totalTime: data[totalTimeFieldName] as String? ?? "",
      docSnapshot: snapshot, // Not stored in Hive
    );
  } catch (e) {
    log('Error processing snapshot data: $e');
    return UserRecipe(
      recipeId: snapshot.id,
      cookingTime: "",
      createDate: DateTime.now(),
      calories: 0,
      imageSrc: "",
      tags: {},
      recipeDescription: "",
      recipeIngredients: [],
      recipeInstructions: [],
      nutritionalInfo: [],
      recipeName: "Unknown Recipe",
      recipeServings: 1,
      updateDate: DateTime.now(),
      cuisinePath: [],
      imageUrl: "",
      identifier: "",
      prepTime: "",
      rating: "",
      totalTime: "",
      docSnapshot: snapshot,
    ); // Continue handling the error gracefully
  }
  }
  }
}