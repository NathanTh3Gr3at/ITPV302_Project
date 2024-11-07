// FirebaseCloudStorage class
import 'dart:async';
// ignore: library_prefixes
import 'dart:developer' as devTools;
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class RecipeStorage {
  RecipeStorage._privateConstructor(this._recipeBox) {
    _initializeStream();
  }

  static RecipeStorage? _instance;
  final Box<CloudRecipe>? _recipeBox;
  final StreamController<List<CloudRecipe>> _recipeController = StreamController.broadcast();
  final recipes = FirebaseFirestore.instance.collection("recipes");
  FirebaseStorage storage = FirebaseStorage.instance;
  DocumentSnapshot? _lastDocument;

  static Future<RecipeStorage> getInstance() async {
    _instance ??= await _createRecipeStorage();
    return _instance!;
  }

  Box<CloudRecipe>? get recipeBox => _recipeBox;

  static Future<RecipeStorage> _createRecipeStorage() async {
    Box<CloudRecipe>? recipeBox;

    if (!kIsWeb) {
      log('Initializing Hive...');
      await Hive.initFlutter();
      Hive.registerAdapter(CloudRecipeAdapter());
      Hive.registerAdapter(RecipeIngredientAdapter());
      Hive.registerAdapter(RecipeInstructionsAdapter());
      log('Opening Hive box...');
      recipeBox = await Hive.openBox<CloudRecipe>("recipes");
      log('Box length after opening: ${recipeBox.length}');
    }

    return RecipeStorage._privateConstructor(recipeBox);
  }

  void _initializeStream() {
    if (_recipeBox != null) {
      _recipeController.add(_recipeBox.values.toList());
      _recipeBox.watch().listen((event) {
        log('Updated cache length: ${_recipeBox.values.length}');
        _recipeController.add(_recipeBox.values.toList());
      });
    }
  }

  Stream<List<CloudRecipe>> get recipeStream => _recipeController.stream;

  List<String> generateSearchKeywords(String term) {
    final List<String> keywords = [];
    for (int i = 1; i <= term.length; i++) {
      keywords.add(term.substring(0, i));
    }
    return keywords;
  }

  void updateRecipeDocument(DocumentReference document, Map<String, dynamic> data) {
    List<String> nameKeywords = generateSearchKeywords(data['recipeName'].toLowerCase());
    data['searchKeywords'] = nameKeywords;
    document.set(data);
  }

  Future<void> fetchAndCacheRecipes({int limit = 500, int startAfter = 0}) async {
    log('Fetching and caching recipes...');
    List<CloudRecipe> fetchedRecipes = await fetchRecipes(startAfterDocument: _lastDocument);
    log('Fetched recipes count: ${fetchedRecipes.length}');
    await cacheRecipes(fetchedRecipes);
    log('Cached recipes count: ${_recipeBox!.length}');
  }

  Future<void> cacheRecipes(List<CloudRecipe> newRecipes) async {
    log('Caching recipes...');
    List<CloudRecipe> currentRecipes = _recipeBox!.values.toList();

    for (var recipe in newRecipes) {
      if (!currentRecipes.any((r) => r.recipeId == recipe.recipeId)) {
        await _recipeBox.add(recipe);
      }
    }

    _recipeController.add(_recipeBox.values.toList());
    log('Recipes cached successfully. Total count: ${_recipeBox.length}');
  }

  Stream<List<CloudRecipe>> getCachedRecipesStream() {
    return _recipeController.stream;
  }
  // to fetch all recipes 

//   Future<void> fetchAndStoreRecipesInHive() async {
//   log("Fetching and storing recipes in Hive...");
//   var box = await Hive.openBox<CloudRecipe>('recipes');
//   bool hasMoreRecipes = true;
//   QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

//   while (hasMoreRecipes) {
//     QuerySnapshot<Map<String, dynamic>> snapshot;
//     if (lastDoc == null) {
//       snapshot = await FirebaseFirestore.instance.collection('recipes').limit(50).get();
//     } else {
//       snapshot = await FirebaseFirestore.instance.collection('recipes')
//           .startAfterDocument(lastDoc)
//           .limit(50)
//           .get();
//     }

//     for (var doc in snapshot.docs) {
//       var recipe = CloudRecipe.fromSnapshot(doc);

//       // Fetch the image URL
//       String? imageUrl = await getImageUrl(recipe.imageSrc);

//       // Store the image URL in the recipe
//       recipe = recipe.copyWith(imageSrc: imageUrl);

//       // Log the recipe before storing it
//       devTools.log("Storing recipe: ${recipe.recipeName} with image URL: ${recipe.imageSrc}");

//       // Store the recipe in Hive
//       await box.put(recipe.recipeId, recipe);
//     }

//     if (snapshot.docs.isNotEmpty) {
//       lastDoc = snapshot.docs.last;
//     }

//     hasMoreRecipes = snapshot.docs.length == 50;  // Continue fetching if the snapshot is full
//   }

//   log("Recipes stored in Hive successfully.");
// }


  // To fetch a limited amount

  Future<void> fetchAndStoreRecipesInHive() async {
    devTools.log("Fetching and storing recipes in Hive...");
    var box = await Hive.openBox<CloudRecipe>('recipes');

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('recipes').get();
    devTools.log("Fetched ${snapshot.docs.length} recipes from Firestore.");

    for (var doc in snapshot.docs) {
      var recipe = CloudRecipe.fromSnapshot(doc as QueryDocumentSnapshot<Map<String, dynamic>>);

      if (recipe.identifier == "kaggle") {
        // Fetch the image URL
        String? imageUrl = await getImageUrl(recipe.imageSrc);
        devTools.log("Fetched image URL: $imageUrl for recipe: ${recipe.recipeId}");

        // Store the image URL in the recipe
        recipe = recipe.copyWith(imageSrc: imageUrl);
      }

      // Store the recipe in Hive
      await box.put(recipe.recipeId, recipe);
      devTools.log("Stored recipe: ${recipe.recipeId} in Hive.");
    }

    devTools.log("Recipes stored in Hive successfully. Total recipes: ${box.length}");
  }


  String convertRating(String rating) {
    if (rating.contains("stars")) {
      return "${rating.replaceAll("stars", "").trim()}.0";
    }
    return rating;
  }

  String toHiveFormat(String input) {
    return input
        .trim()
        .toUpperCase()
        .replaceAll(' ', '_');
  }

Future<List<CloudRecipe>> fetchRecipes({
  int limit = 500,
  int pageIndex = 0,
  DocumentSnapshot? startAfterDocument,
  String searchQuery = '',
  List<String>? diets,
  List<String>? ingredients,
  List<String>? mealTypes,
  List<String>? ratings,
  List<String>? prepTimes,
  List<String>? cookingTimes,
  List<String>? totalTimes,
  List<String>? health,
}) async {
  List<CloudRecipe> filteredRecipes = [];

  if (kIsWeb) {
    filteredRecipes = await fetchRecipesFromWeb(
      limit: limit,
      startAfterDocument: startAfterDocument,
      searchQuery: searchQuery,
      diets: diets,
      ingredients: ingredients,
      mealTypes: mealTypes,
      ratings: ratings,
      prepTimes: prepTimes,
      cookingTimes: cookingTimes,
      totalTimes: totalTimes,
      health: health,
    );
  } else {
    
    final box = Hive.box<CloudRecipe>('recipes');
    
    if (box.isEmpty) {
      await fetchAndStoreRecipesInHive();
    }

    filteredRecipes = box.values.where((recipe) {
      bool matches = true;
      String searchKeyword = searchQuery.toLowerCase();
      
      if (searchQuery.isNotEmpty) {
        matches = matches && recipe.recipeSearchKeywords.contains(searchKeyword);
      }
      if (ratings != null) {
        ratings = ratings!.map((rating) => convertRating(rating)).toList();
      }

    // Convert health filters to Hive format
    if (health != null) {
      health = health!.map((item) => toHiveFormat(item)).toList();
      }
      
      List<String> combinedDietsAndHealth = [];
      if (diets != null) combinedDietsAndHealth.addAll(diets.map((diet) => toHiveFormat(diet)));
      if (health != null) combinedDietsAndHealth.addAll(health!);
      
      if (combinedDietsAndHealth.isNotEmpty) {
        bool labelMatch = (recipe.tags['diet_labels'] as List<dynamic>?)?.any((label) => combinedDietsAndHealth.contains(label)) == true ||
                          (recipe.tags['health_labels'] as List<dynamic>?)?.any((label) => combinedDietsAndHealth.contains(label)) == true;
        matches = matches && labelMatch;
      }

      if (ingredients != null && ingredients.isNotEmpty) {
        matches = matches && ingredients.every((ingredient) => recipe.recipeIngredients.any((item) => item.ingredientName?.toLowerCase() == ingredient.toLowerCase()));
      }

      if (mealTypes != null && mealTypes.isNotEmpty) {
        matches = matches && (recipe.cuisinePath?.any((type) => mealTypes.contains(type)) == true);
      }

      if (ratings != null && ratings!.isNotEmpty) {
        matches = matches && ratings!.contains(recipe.rating);
      }

      if (prepTimes != null && prepTimes.isNotEmpty) {
        matches = matches && prepTimes.contains(recipe.prepTime);
      }

      if (cookingTimes != null && cookingTimes.isNotEmpty) {
        matches = matches && cookingTimes.contains(recipe.cookingTime);
      }

      if (totalTimes != null && totalTimes.isNotEmpty) {
        matches = matches && totalTimes.contains(recipe.totalTime);
      }
      
      return matches;
    }).toList();
  }

  int start = pageIndex * limit;
  int end = start + limit;
  if (start >= filteredRecipes.length) {
    return [];
  }

  List<CloudRecipe> displayedRecipes = filteredRecipes.sublist(start, end > filteredRecipes.length ? filteredRecipes.length : end);
  return displayedRecipes;
}

//   Future<List<CloudRecipe>> fetchRecipes({
//   int limit = 500,
//   int pageIndex = 0,
//   DocumentSnapshot? startAfterDocument,
//   String searchQuery = '',
//   List<String>? diets,
//   List<String>? ingredients,
//   List<String>? mealTypes,
//   List<String>? ratings,
//   List<String>? prepTimes,
//   List<String>? cookingTimes,
//   List<String>? totalTimes,
//   List<String>? health,
// }) async {
//   // Check if theres recipes first
//   await fetchAndStoreRecipesInHive();

//   final box = Hive.box<CloudRecipe>('recipes');
  
//   // Check if there's a search query
//   searchQuery = searchQuery.trim();
//   String searchKeyword = searchQuery.toLowerCase();
//   log("Searching for keyword: $searchKeyword");
//   if (ratings != null) {
//     ratings = ratings.map((rating) => convertRating(rating)).toList();
//   }

//   // Convert health filters to Hive format
//   if (health != null) {
//     health = health.map((item) => toHiveFormat(item)).toList();
//   }
//   log("Health filters: $health");
//   // Search the Hive cache with filters
//   List<CloudRecipe> filteredRecipes = box.values.where((recipe) {
//     bool matches = true;
//     // log("Recipe ID: ${recipe.recipeId}, Tags: ${recipe.tags}");

//   List<String> combinedDietsAndHealth = [];
//   if (diets != null) combinedDietsAndHealth.addAll(diets.map((diet) => toHiveFormat(diet)));
//   if (health != null) combinedDietsAndHealth.addAll(health);
//   log("Combined Filters: $combinedDietsAndHealth");

//     if (searchQuery.isNotEmpty) {
//       matches = matches && recipe.recipeSearchKeywords.contains(searchKeyword);
//     }

//     // Filter using combined diets and health labels
//     if (combinedDietsAndHealth.isNotEmpty) {
//       bool labelMatch = (recipe.tags['dietLabels'] as List<dynamic>?)?.any((label) => combinedDietsAndHealth.contains(label)) == true ||
//                         (recipe.tags['health_labels'] as List<dynamic>?)?.any((label) => combinedDietsAndHealth.contains(label)) == true;
//       matches = matches && labelMatch;
//     }

//     if (ingredients != null && ingredients.isNotEmpty) {
//       matches = matches && ingredients.every((ingredient) => recipe.recipeIngredients.any((item) => item.ingredientName?.toLowerCase() == ingredient.toLowerCase()));
//     }

//     if (mealTypes != null && mealTypes.isNotEmpty) {
//       matches = matches && (recipe.cuisinePath?.any((type) => mealTypes.contains(type)) == true);
//     }

//     if (ratings != null && ratings.isNotEmpty) {
//       matches = matches && ratings.contains(recipe.rating);
//     }

//     if (prepTimes != null && prepTimes.isNotEmpty) {
//       matches = matches && prepTimes.contains(recipe.prepTime);
//     }

//     if (cookingTimes != null && cookingTimes.isNotEmpty) {
//       matches = matches && cookingTimes.contains(recipe.cookingTime);
//     }

//     if (totalTimes != null && totalTimes.isNotEmpty) {
//       matches = matches && totalTimes.contains(recipe.totalTime);
//     }

//     // if (health != null && health.isNotEmpty) {
//     //   bool healthMatch = (recipe.tags['health_labels'] as List<dynamic>?)?.any((label) {
//     //     log('Label: $label, Matches: ${health!.contains(label)}');
//     //     return health.contains(label);
//     //   }) == true;
//     //   matches = matches && healthMatch;
//     // }
    
//     return matches;
//   }).toList();

//   // If found in cache, return the cached recipes
//   // if (filteredRecipes.isNotEmpty) {
//   //   log('Found ${filteredRecipes.length} recipes in the cache matching filters.');
//   //   return filteredRecipes.skip(startIndex).take(limit).toList();
//   // }
//   // log(filteredRecipes[1].rating!);
//   // Implement pagination using slice
//   log('Found ${filteredRecipes.length} recipes in the cache matching filters.');

//   // Ensure image URLs are fetched for filtered recipes
//   for (var recipe in filteredRecipes) {
//     if (recipe.imageSrc == null || recipe.imageSrc!.isEmpty) {
//       recipe.imageSrc = await getImageUrl(recipe.imageSrc);
//     }
//   }

//   // Implement pagination using slice
//   int start = pageIndex * limit;
//   int end = start + limit;
//   if (start >= filteredRecipes.length) {
//     return [];
//   }
//   List<CloudRecipe> displayedRecipes = filteredRecipes.sublist(start, end > filteredRecipes.length ? filteredRecipes.length : end);

//   return displayedRecipes;
// }


// Searching one 
Future<List<CloudRecipe>> fetchRecipesFromWeb({
  int limit = 20,
  DocumentSnapshot? startAfterDocument,
  String searchQuery = '',
  List<String>? diets,
  List<String>? ingredients,
  List<String>? mealTypes,
  List<String>? ratings,
  List<String>? prepTimes,
  List<String>? cookingTimes,
  List<String>? totalTimes,
  List<String>? health,
}) async {
  // Check if there's a search query
  String searchKeyword = searchQuery.toLowerCase();
  log("Searching for keyword: $searchKeyword");

  // Initialize Firestore query
  Query<Map<String, dynamic>> query = recipes;
  if (searchQuery.isNotEmpty) {
    query = query.where('searchKeywords', arrayContains: searchKeyword);
  }

  if (diets != null && diets.isNotEmpty) {
    for (String diet in diets) {
      query = query.where('tags.diet_labels', arrayContains: diet);
    }
  }

  if (health != null && health.isNotEmpty) {
    for (String healthItem in health) {
      query = query.where('tags.health_labels', arrayContains: healthItem);
    }
  }

  if (ingredients != null && ingredients.isNotEmpty) {
    // Handle ingredients filter (you might need to adjust according to your Firestore structure)
    for (String ingredient in ingredients) {
      query = query.where('recipe_ingredients', arrayContains: ingredient.toLowerCase());
    }
  }

  if (mealTypes != null && mealTypes.isNotEmpty) {
    query = query.where('cuisine_path', arrayContainsAny: mealTypes);
  }

  if (ratings != null && ratings.isNotEmpty) {
    query = query.where('rating', whereIn: ratings);
  }

  if (prepTimes != null && prepTimes.isNotEmpty) {
    query = query.where('prep_time', whereIn: prepTimes);
  }

  if (cookingTimes != null && cookingTimes.isNotEmpty) {
    query = query.where('cooking_time', whereIn: cookingTimes);
  }

  if (totalTimes != null && totalTimes.isNotEmpty) {
    query = query.where('total_time', whereIn: totalTimes);
  }

  if (startAfterDocument != null) {
    query = query.startAfterDocument(startAfterDocument);
  }

  // Execute query and get snapshot
  QuerySnapshot<Map<String, dynamic>> snapshot = await query.where("identifier", isEqualTo: "kaggle").limit(limit).get();
  _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

  log("Fetched recipes count from Firestore: ${snapshot.size}");

  // Process documents into CloudRecipe objects
  List<Future<CloudRecipe?>> recipeFutures = snapshot.docs.map((doc) async {
    try {
      CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
      if (recipe.recipeName == "Unknown Recipe") {
        return null;
      }

      if (recipe.imageSrc != null && recipe.imageSrc!.isNotEmpty) {
        recipe.imageSrc = await getImageUrl(recipe.imageSrc);
      }

      log('Image URL: ${recipe.imageUrl}');
      return recipe;
    } catch (e) {
      log('Error processing recipe: $e');
      return null;
    }
  }).toList();

  // Await all futures and filter out nulls
  List<CloudRecipe?> allRecipes = await Future.wait(recipeFutures);
  List<CloudRecipe> finalRecipes = allRecipes.where((recipe) => recipe != null).cast<CloudRecipe>().toList();

  return finalRecipes;
}



  Future<void> fetchMoreRecipes({int limit = 25, String searchQuery = ''}) async {
    List<CloudRecipe> fetchedRecipes = await fetchRecipes(startAfterDocument: _lastDocument, searchQuery: searchQuery);
    await cacheRecipes(fetchedRecipes);
    log('Fetched more recipes count: ${fetchedRecipes.length}');
    log('Total cached recipes count: ${_recipeBox!.length}');
  }
  // Getting all recipes from the database --> Limited to 20
  Stream<List<CloudRecipe>> getAllRecipes({int limit = 20}) {
  return recipes.limit(limit).snapshots().asyncMap((snapshot) async {
    try {
      List<CloudRecipe> allRecipes = await Future.wait(
        snapshot.docs.map((doc) async {
          CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
          recipe.imageSrc = await getImageUrl(recipe.imageSrc);
          return recipe;
        }).toList(),
      );
      return allRecipes;
    } catch (e) {
      devTools.log("Error fetching recipes: $e");
      return [];
    }
  });
}

  Future<String?> getImageUrl(String? imageName) async {
    if (imageName == null || imageName.isEmpty) return null;
    try {
      String downloadUrl = await storage.ref("recipe_images/$imageName").getDownloadURL();
      devTools.log("fetching the URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      devTools.log("There was an error fetching the URL: $imageName");
      return null;
    }
  }
  // RecipeStorage._sharedInstance(this._recipeBox);
  // static final RecipeStorage _shared = RecipeStorage._sharedInstance();
  // factory RecipeStorage() => _shared;


  
  // Opening the Hive Box once recipeStorage is initializd so reicpes are cached immediately upon entry
  // Box<CloudRecipe>? get recipeBox => _recipeBox;
}

// initial fetch
// Future<List<CloudRecipe>> fetchRecipes({
//   int limit = 200,
//   DocumentSnapshot? startAfterDocument,
//   String? searchQuery,
// }) async {
//   final box = Hive.box<CloudRecipe>('recipes');

//   // Check if there's a search query
//   if (searchQuery != null && searchQuery.isNotEmpty) {
//     String searchKeyword = searchQuery.toLowerCase();
//     log("Searching for keyword: $searchKeyword");

//     // Search the Hive cache
//     List<CloudRecipe> cachedRecipes = box.values.where((recipe) {
//       return recipe.recipeSearchKeywords.contains(searchKeyword);
//     }).toList();

//     // If found in cache, return the cached recipes
//     if (cachedRecipes.isNotEmpty) {
//       return cachedRecipes;
//     }
//   }

//   // If not found in cache or there's no search query, query Firestore
//   Query<Map<String, dynamic>> query = recipes.limit(limit);
//   if (searchQuery != null && searchQuery.isNotEmpty) {
//     String searchKeyword = searchQuery.toLowerCase();
//     query = query.where('searchKeywords', arrayContains: searchKeyword);
//   }

//   if (startAfterDocument != null) {
//     query = query.startAfterDocument(startAfterDocument);
//   }

//   QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
//   _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

//   List<Future<CloudRecipe?>> recipeFutures = snapshot.docs.map((doc) async {
//     try {
//       CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
//       if (recipe.recipeName == "Unknown Recipe") {
//         return null;
//       }
//       recipe.imageSrc = await getImageUrl(recipe.imageSrc);
//       return recipe;
//     } catch (e) {
//       log('Error processing recipe: $e');
//       return null;
//     }
//   }).toList();

//   List<CloudRecipe?> allRecipes = await Future.wait(recipeFutures);
//   List<CloudRecipe> finalRecipes = allRecipes.where((recipe) => recipe != null).cast<CloudRecipe>().toList();

//   // Cache the new recipes
//   for (var recipe in finalRecipes) {
//     box.put(recipe.recipeId, recipe);
//   }

//   return finalRecipes;
// }