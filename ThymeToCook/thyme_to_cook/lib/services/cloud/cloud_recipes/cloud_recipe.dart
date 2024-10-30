// For checking purposes 
// import 'dart:developer';
import 'dart:developer';
import 'package:decimal/decimal.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:fraction/fraction.dart';
import 'package:hive/hive.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_storage_constants.dart';

part "cloud_recipe.g.dart";

@HiveType(typeId: 1)
class RecipeIngredient {
  @HiveField(0)
  final String? ingredientName;
  @HiveField(1)
  final double? quantity;
  @HiveField(2)
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
@HiveType(typeId: 2)
class RecipeInstructions {
  @HiveField(0)
  String? instruction;
  @HiveField(1)
  int? time;
  @HiveField(2)
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
@HiveType(typeId: 0)
class CloudRecipe {
  @HiveField(0)
  String recipeId;
  @HiveField(1)
  String? cookingTime;
  @HiveField(2)
  DateTime createDate;
  @HiveField(3)
  int? calories;
  // For the jpg not the actual url
  @HiveField(4)
  String? imageSrc;
  @HiveField(5)
  Map<String, dynamic> tags;
  @HiveField(6)
  String? recipeDescription;
  @HiveField(7)
  List<RecipeIngredient> recipeIngredients;
  @HiveField(8)
  List<RecipeInstructions> recipeInstructions;
  @HiveField(9)
  List<String> nutritionalInfo;
  @HiveField(10)
  String recipeName;
  @HiveField(11)
  int? recipeServings;
  @HiveField(12)
  DateTime updateDate;
  @HiveField(13)
  List<String>? cuisinePath;
  @HiveField(14)
  String? imageUrl;
  @HiveField(15)
  String? identifier;
  @HiveField(16)
  String? prepTime;
  @HiveField(17)
  String? rating;
  @HiveField(18)
  String? totalTime; 
  
  DocumentSnapshot<Map<String, dynamic>>? docSnapshot;


  CloudRecipe({
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

  factory CloudRecipe.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
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

    return CloudRecipe(
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
    return CloudRecipe(
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// @immutable
// class CloudRecipe {
//   final int calories;
//   final int cookingTime;
//   final DateTime createDate;
//   final String imageUrl;
//   final List<String> nutritionalInfo;
//   final String recipeDescription;
//   final List<String> recipeIngredients;
//   final List<String> recipeInstructions;
//   final String recipeName;
//   final String recipeServings;
//   final Map<String, List<String>> tags;
//   // final String tags;
//   final DateTime updateDate;

//   // final bool liked;

//   const CloudRecipe({
//     required this.calories,
//     required this.cookingTime,
//     required this.createDate,
//     required this.imageUrl,
//     required this.nutritionalInfo,
//     required this.recipeDescription,
//     required this.recipeIngredients,
//     required this.recipeInstructions,
//     required this.recipeName,
//     required this.recipeServings,
//     required this.tags,
//     required this.updateDate,
//     // this.liked = false,
//   });

//   // const CloudRecipe(
//   //     this.cookingTime,
//   //     this.createDate,
//   //     this.imageUrl,
//   //     this.tags,
//   //     this.recipeDescription,
//   //     this.recipeIngredients,
//   //     this.recipeInstructions,
//   //     this.recipeName,
//   //     this.recipeServings,
//   //     this.updateDate);

//   // for saving data to the firestore
//   // Map<String, dynamic> toJson() {
//   //   return {
//   //     // 'calories': calories,
//   //     'cooking_time': cookingTime,
//   //     'create_date': createDate,
//   //     'image_url': imageUrl,
//   //     // 'nutritional_info': nutritionalInfo,
//   //     'recipe_description': recipeDescription,
//   //     'recipe_ingredients': recipeIngredients,
//   //     'recipe_instructions': recipeInstructions,
//   //     'recipe_name': recipeName,
//   //     'recipe_servings': recipeServings,
//   //     'tags': tags,
//   //     'update_date': updateDate,
//   //   };
//   // }

//   // converting json to cloud recipe for pulling data
//   factory CloudRecipe.fromJson(Map<String, dynamic> json) {
//     // print(json);    // for debugging
//     try {
//       return CloudRecipe(
//         calories: json['calories'] ?? 0,
//         cookingTime: json['cooking_time'] ?? 0,
//         createDate: (json['create_date'] as Timestamp).toDate(),
//         imageUrl: json['image_url'] ?? '',
//         nutritionalInfo: List<String>.from(json['nutritional_info'] ?? []),
//         recipeDescription: json['recipe_description'] ?? '',
//         // converts into a list of strings, then uses maps each ingredient name to a list
//         recipeIngredients: List<String>.from(
//             json['recipe_ingredients']?.map((e) => e['ingredient_name']) ?? []),
//         recipeInstructions: List<String>.from(
//             json['recipe_instructions']?.map((e) => e['instruction']) ?? []),
//         recipeName: json['recipe_name'] ?? '',
//         recipeServings: json['recipe_servings'] ?? '',

//         // converts tags map to key type of string with value string
//         tags: (json['tags'] is Map) // checks if tag is a map field
//             // if tag is a map then convert key to string and value to List<string>
//             ? (json['tags'] as Map<String, dynamic>)
//                 .map<String, List<String>>((key, value) {
//                 return MapEntry(key, List<String>.from(value as List<dynamic>));
//               })
//             : <String, List<String>>{},

//         updateDate: (json['update_date'] as Timestamp).toDate(),
//       );
//     } catch (e) {
//       print("Error getting CloudRecipe: $e");
//       throw Exception("Error parsing CloudRecipe: $e");
//     }
//   }
// }
}