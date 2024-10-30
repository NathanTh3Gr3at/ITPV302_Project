// FirebaseCloudStorage class
import 'dart:async';
// ignore: library_prefixes
import 'dart:developer' as devTools;
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:hive/hive.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class RecipeStorage {
  final Box<CloudRecipe> _recipeBox;
  // Controller responsible for getting the recipes displayed in a stream
  final StreamController<List<CloudRecipe>> _recipeController = StreamController.broadcast();
  final recipes = FirebaseFirestore.instance.collection("recipes");
  FirebaseStorage storage = FirebaseStorage.instance;
  // Getting Kaggle Recipes 

  // Initialize the streamController 
  void _initializeStream() {
    _recipeController.add(_recipeBox.values.toList());
    _recipeBox.watch().listen((event) {
      devTools.log('Updated cache length: ${_recipeBox.values.length}');
      _recipeController.add(_recipeBox.values.toList()); //--> mitting the updated list
    });
  }

  Future<void> fetchAndCacheRecipes({int limit = 250, int startAfter = 0}) async {
    List<CloudRecipe> fetchedRecipes = await fetchRecipes(limit: limit);
    devTools.log('Fetched recipes count: ${fetchedRecipes.length}');
    await cacheRecipes(fetchedRecipes);
    devTools.log('Cached recipes count: ${_recipeBox.length}');
  }

  // Cache recipes after we get them from the database
 Future<void> cacheRecipes(List<CloudRecipe> newRecipes) async {
    // Get current recipes from the box
    List<CloudRecipe> currentRecipes = _recipeBox.values.toList();

    // Add new recipes ensuring no duplicates
    for (var recipe in newRecipes) {
      if (!currentRecipes.any((r) => r.recipeId == recipe.recipeId)) {
        await _recipeBox.add(recipe);
      }
    }

    // Update the stream
    _recipeController.add(_recipeBox.values.toList());
  }

  Stream<List<CloudRecipe>> getCachedRecipesStream() {
    return _recipeController.stream;
  }


Future<List<CloudRecipe>> fetchRecipes({
    int limit = 250,
    DocumentSnapshot? startAfterDocument,
    String? searchQuery,
  }) async {
    Query<Map<String, dynamic>> query = recipes.limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.where('recipe_name', isGreaterThanOrEqualTo: searchQuery)
                   .where('recipe_name', isLessThanOrEqualTo: '$searchQuery\uf8ff');
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    List<Future<CloudRecipe?>> recipeFutures = snapshot.docs.map((doc) async {
      try {
        CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
        if (recipe.calories == 0 || recipe.recipeName == "Unknown Recipe") {
          return null;
        }
        recipe.imageSrc = await getImageUrl(recipe.imageSrc);
        return recipe;
      } catch (e) {
        log('Error processing recipe: $e');
        return null;
      }
    }).toList();

    List<CloudRecipe?> allRecipes = await Future.wait(recipeFutures);
    return allRecipes.where((recipe) => recipe != null).cast<CloudRecipe>().toList();
  }  

  // Getting all recipes from the database --> Limited to 200
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

// So we have to check for similar results 

// Stream<List<CloudRecipe>> getRecipeByName ({String searchString = ""}) {

// }

// Future<bool> checkIfRecipeName ({String searchString = "", String recipeName = ""}) {
//   if (searchString.contains(recipeName)) {
//     return true;
//   }
// }

//   Stream<Iterable<CloudRecipe>> getAllKaggleRecipes({int limit = 10}) {
//   return recipes.where(identifierFieldName, isEqualTo: "kaggle")
//       .limit(limit)
//       .snapshots()
//       .asyncMap((snapshot) async {
//     try {
//       List<CloudRecipe> allRecipes = await Future.wait(
//         snapshot.docs.map((doc) async {
//           CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
//           recipe.imageSrc = await getImageUrl(recipe.imageSrc);
//           return recipe;
//         }).toList(),
//       );
//       return allRecipes;
//     } catch (e) {
//       DevTools.log("Error fetching Kaggle recipes: $e");
//       return [];
//     }
//   });
// }

  // Stream<Iterable<CloudRecipe>> getRecipeByName ({String? recipeName}) {
  //   if (recipeName != null) {
  //     return recipes.where(
        
  //     )
  //   } else {

  //   }
  // }

  // Getting the vegan recipes
//   Stream<Iterable<CloudRecipe>> getVeganRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.health_labels", arrayContains: "VEGAN"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allVeganRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe veganRecipe = CloudRecipe.fromSnapshot(doc);
//         veganRecipe.imageSrc = await getImageUrl(veganRecipe.imageSrc);
//         return veganRecipe; 
//       }));
//       return allVeganRecipes;
//     });
//   }

//   Stream<Iterable<CloudRecipe>> getDessertRecipes ({int limit = 1}) {
//     return recipes.where(
//       recipeNameFieldName, isEqualTo: "ice"
//     )
//     .where(identifierFieldName, isEqualTo: "allRecipes")
//     .limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allDessertRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
//         return recipe;
//       }));

//       return allDessertRecipes;
//     });
//   }

//  Future<Iterable<CloudRecipe>> filterCategories(
//     String searchCategory,
//     int itemCount,
//     Iterable<CloudRecipe> cloudRecipe) async {
  
//   List<CloudRecipe> myCloudRecipes = [];

//   for (int index = 0; index < itemCount; index++) {
//     // Get the cuisine path list for the current recipe
//     List<dynamic>? cuisinePathList = cloudRecipe.elementAt(index).cuisinePath;

//     // Check if cuisinePathList is not null
//     if (cuisinePathList != null) {
//       // Check if any item in the cuisinePathList contains the search category
//       if (cuisinePathList.any((cuisine) => cuisine.toString().toLowerCase().contains(searchCategory.toLowerCase()))) {
//         // If a match is found, add the recipe to the filtered list
//         myCloudRecipes.add(cloudRecipe.elementAt(index));
//       }
//     }
//   }

//   // Return the filtered recipes as an Iterable
//   return myCloudRecipes;
// }



//   Stream<Iterable<CloudRecipe>> getAllOnlineRecipes({int limit = 10}) {
//   return recipes.where(identifierFieldName, isEqualTo: "allRecipes")
//       .limit(limit)
//       .snapshots()
//       .asyncMap((snapshot) async {
//     try {
//       List<CloudRecipe> allRecipes = await Future.wait(
//         snapshot.docs.map((doc) async {
//           CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
//           return recipe;
//         }).toList(),
//       );
//       return allRecipes;
//     } catch (e) {
//       DevTools.log("Error fetching Kaggle recipes: $e");
//       return [];
//     }
//   });
// }



//   // Getting the vegetarian recipes
//   Stream<Iterable<CloudRecipe>> getVegetarianRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.health_labels", arrayContains: "VEGETARIAN"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allVegetarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe vegetarianRecipe = CloudRecipe.fromSnapshot(doc);
//         vegetarianRecipe.imageSrc = await getImageUrl(vegetarianRecipe.imageSrc);
//         return vegetarianRecipe;
//       }));
//       return allVegetarianRecipes;
//     });
//   }
//   // Getting the paleo recipes 
//     Stream<Iterable<CloudRecipe>> getPaleoRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.health_labels", arrayContains: "PALEO"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allPaleoRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe paleoRecipe = CloudRecipe.fromSnapshot(doc);
//         paleoRecipe.imageSrc = await getImageUrl(paleoRecipe.imageSrc);
//         return paleoRecipe;
//       }));
//       return allPaleoRecipes;
//     });
//   }
//   // Getting the keto recipes 
//   Stream<Iterable<CloudRecipe>> getKetoRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.health_labels", arrayContains: "KETO_FRIENDLY"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allKetoRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe ketoRecipe = CloudRecipe.fromSnapshot(doc);
//         ketoRecipe.imageSrc = await getImageUrl(ketoRecipe.imageSrc);
//         return ketoRecipe;
//       }));
//       return allKetoRecipes;
//     });
//   }
//   // Getting Gluten Free Recipes



// // Getting Gluten-Free Recipes with Randomization
// Stream<Iterable<CloudRecipe>> getGlutenFreeRecipes({int limit = 12}) {
//   return recipes
//       .limit(limit)
//       .snapshots()
//       .asyncMap((snapshot) async {
//         List<CloudRecipe> filteredRecipes = snapshot.docs.map((doc) {
//           CloudRecipe glutenFreeRecipe = CloudRecipe.fromSnapshot(doc);
//           List<String>? cautions = glutenFreeRecipe.tags["cautions"]?.cast<String>();

//           if (cautions == null || !cautions.contains("GLUTEN")) {
//             return glutenFreeRecipe;
//           }
//           return null; 
//         }).where((recipe) => recipe != null).cast<CloudRecipe>().toList();

//         List<CloudRecipe> allGlutenFreeRecipes = await Future.wait(
//           filteredRecipes.map((recipe) async {
//             recipe.imageSrc = await getImageUrl(recipe.imageSrc);
//             return recipe;
//           }).toList(),
//         );

//         allGlutenFreeRecipes.shuffle(Random());

//         return allGlutenFreeRecipes;
//       });
// }

//   // Getting Pescatarian Recipes
//   Stream<Iterable<CloudRecipe>> getPescatarianRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.health_labels", arrayContains: "PESCATARIAN"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allPescatarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe pescatarianRecipe = CloudRecipe.fromSnapshot(doc);
//         pescatarianRecipe.imageSrc = await getImageUrl(pescatarianRecipe.imageSrc);
//         return pescatarianRecipe;
//       }));
//       return allPescatarianRecipes;
//     });
//   }
//   //Fixxxxx!!!
//     // Getting Low carb recipes
//   Stream<Iterable<CloudRecipe>> getLowCarbRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.diet_labels", arrayContains: "LOW_CARB"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allPescatarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe pescatarianRecipe = CloudRecipe.fromSnapshot(doc);
//         pescatarianRecipe.imageSrc = await getImageUrl(pescatarianRecipe.imageSrc);
//         return pescatarianRecipe;
//       }));
//       return allPescatarianRecipes;
//     });
//   }

//   // Getting low sodium recipes
//   Stream<Iterable<CloudRecipe>> getLowSodiumRecipes ({int limit = 12}) {
//     return recipes.where(
//       "$tagsFieldName.diet_labels", arrayContains: "LOW_SODIUM"
//     ).limit(limit)
//     .snapshots()
//     .asyncMap((snapshot) async {
//       List<CloudRecipe> allPescatarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
//         CloudRecipe pescatarianRecipe = CloudRecipe.fromSnapshot(doc);
//         pescatarianRecipe.imageSrc = await getImageUrl(pescatarianRecipe.imageSrc);
//         return pescatarianRecipe;
//       }));
//       return allPescatarianRecipes;
//     });
//   }

  Future<String?> getImageUrl(String? imageName) async {
    if (imageName == null || imageName.isEmpty) return null;
    try {
      String  downloadUrl = await storage.ref("recipe_images/$imageName").getDownloadURL();
      return downloadUrl;
    } catch(e) {
      devTools.log("There was an error fetching the URL: $imageName");
      return null;
    }
  }
  // RecipeStorage._sharedInstance(this._recipeBox);
  // static final RecipeStorage _shared = RecipeStorage._sharedInstance();
  // factory RecipeStorage() => _shared;


  // New singleton implementing our hive
  RecipeStorage._privateConstructor(this._recipeBox) {
    _initializeStream();
  }
  static RecipeStorage? _instance;
  // Opening the Hive Box once recipeStorage is initializd so reicpes are cached immediately upon entry
  static Future<RecipeStorage> getInstance() async {
    if (_instance == null) {
      var recipeBox = await Hive.openBox<CloudRecipe>("recipes");
      _instance = RecipeStorage._privateConstructor(recipeBox);
    }
    return _instance!;
  }
}