// FirebaseCloudStorage class
import 'dart:developer' as DevTools;
import 'dart:math'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_storage_constants.dart';

class RecipeStorage {
  
  final recipes = FirebaseFirestore.instance.collection("recipes");
  FirebaseStorage storage = FirebaseStorage.instance;
  // Getting Kaggle Recipes 
  Stream<Iterable<CloudRecipe>> getAllKaggleRecipes({int limit = 10}) {
  return recipes.where(identifierFieldName, isEqualTo: "kaggle")
      .limit(limit)
      .snapshots()
      .asyncMap((snapshot) async {
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
      DevTools.log("Error fetching Kaggle recipes: $e");
      return [];
    }
  });
}

  // Getting the vegan recipes
  Stream<Iterable<CloudRecipe>> getVeganRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.health_labels", arrayContains: "VEGAN"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allVeganRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe veganRecipe = CloudRecipe.fromSnapshot(doc);
        veganRecipe.imageSrc = await getImageUrl(veganRecipe.imageSrc);
        return veganRecipe; 
      }));
      return allVeganRecipes;
    });
  }

  Stream<Iterable<CloudRecipe>> getDessertRecipes ({int limit = 1}) {
    return recipes.where(
      recipeNameFieldName, isEqualTo: "ice"
    )
    .where(identifierFieldName, isEqualTo: "allRecipes")
    .limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allDessertRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
        return recipe;
      }));

      return allDessertRecipes;
    });
  }

 Future<Iterable<CloudRecipe>> filterCategories(
    String searchCategory,
    int itemCount,
    Iterable<CloudRecipe> cloudRecipe) async {
  
  List<CloudRecipe> myCloudRecipes = [];

  for (int index = 0; index < itemCount; index++) {
    // Get the cuisine path list for the current recipe
    List<dynamic>? cuisinePathList = cloudRecipe.elementAt(index).cuisinePath;

    // Check if cuisinePathList is not null
    if (cuisinePathList != null) {
      // Check if any item in the cuisinePathList contains the search category
      if (cuisinePathList.any((cuisine) => cuisine.toString().toLowerCase().contains(searchCategory.toLowerCase()))) {
        // If a match is found, add the recipe to the filtered list
        myCloudRecipes.add(cloudRecipe.elementAt(index));
      }
    }
  }

  // Return the filtered recipes as an Iterable
  return myCloudRecipes;
}



  Stream<Iterable<CloudRecipe>> getAllOnlineRecipes({int limit = 10}) {
  return recipes.where(identifierFieldName, isEqualTo: "allRecipes")
      .limit(limit)
      .snapshots()
      .asyncMap((snapshot) async {
    try {
      List<CloudRecipe> allRecipes = await Future.wait(
        snapshot.docs.map((doc) async {
          CloudRecipe recipe = CloudRecipe.fromSnapshot(doc);
          return recipe;
        }).toList(),
      );
      return allRecipes;
    } catch (e) {
      DevTools.log("Error fetching Kaggle recipes: $e");
      return [];
    }
  });
}



  // Getting the vegetarian recipes
  Stream<Iterable<CloudRecipe>> getVegetarianRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.health_labels", arrayContains: "VEGETARIAN"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allVegetarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe vegetarianRecipe = CloudRecipe.fromSnapshot(doc);
        vegetarianRecipe.imageSrc = await getImageUrl(vegetarianRecipe.imageSrc);
        return vegetarianRecipe;
      }));
      return allVegetarianRecipes;
    });
  }
  // Getting the paleo recipes 
    Stream<Iterable<CloudRecipe>> getPaleoRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.health_labels", arrayContains: "PALEO"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allPaleoRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe paleoRecipe = CloudRecipe.fromSnapshot(doc);
        paleoRecipe.imageSrc = await getImageUrl(paleoRecipe.imageSrc);
        return paleoRecipe;
      }));
      return allPaleoRecipes;
    });
  }
  // Getting the keto recipes 
  Stream<Iterable<CloudRecipe>> getKetoRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.health_labels", arrayContains: "KETO_FRIENDLY"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allKetoRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe ketoRecipe = CloudRecipe.fromSnapshot(doc);
        ketoRecipe.imageSrc = await getImageUrl(ketoRecipe.imageSrc);
        return ketoRecipe;
      }));
      return allKetoRecipes;
    });
  }
  // Getting Gluten Free Recipes



// Getting Gluten-Free Recipes with Randomization
Stream<Iterable<CloudRecipe>> getGlutenFreeRecipes({int limit = 12}) {
  return recipes
      .limit(limit)
      .snapshots()
      .asyncMap((snapshot) async {
        List<CloudRecipe> filteredRecipes = snapshot.docs.map((doc) {
          CloudRecipe glutenFreeRecipe = CloudRecipe.fromSnapshot(doc);
          List<String>? cautions = glutenFreeRecipe.tags["cautions"]?.cast<String>();

          if (cautions == null || !cautions.contains("GLUTEN")) {
            return glutenFreeRecipe;
          }
          return null; 
        }).where((recipe) => recipe != null).cast<CloudRecipe>().toList();

        List<CloudRecipe> allGlutenFreeRecipes = await Future.wait(
          filteredRecipes.map((recipe) async {
            recipe.imageSrc = await getImageUrl(recipe.imageSrc);
            return recipe;
          }).toList(),
        );

        allGlutenFreeRecipes.shuffle(Random());

        return allGlutenFreeRecipes;
      });
}

  // Getting Pescatarian Recipes
  Stream<Iterable<CloudRecipe>> getPescatarianRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.health_labels", arrayContains: "PESCATARIAN"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allPescatarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe pescatarianRecipe = CloudRecipe.fromSnapshot(doc);
        pescatarianRecipe.imageSrc = await getImageUrl(pescatarianRecipe.imageSrc);
        return pescatarianRecipe;
      }));
      return allPescatarianRecipes;
    });
  }
  //Fixxxxx!!!
    // Getting Low carb recipes
  Stream<Iterable<CloudRecipe>> getLowCarbRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.diet_labels", arrayContains: "LOW_CARB"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allPescatarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe pescatarianRecipe = CloudRecipe.fromSnapshot(doc);
        pescatarianRecipe.imageSrc = await getImageUrl(pescatarianRecipe.imageSrc);
        return pescatarianRecipe;
      }));
      return allPescatarianRecipes;
    });
  }

  // Getting low sodium recipes
  Stream<Iterable<CloudRecipe>> getLowSodiumRecipes ({int limit = 12}) {
    return recipes.where(
      "$tagsFieldName.diet_labels", arrayContains: "LOW_SODIUM"
    ).limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      List<CloudRecipe> allPescatarianRecipes = await Future.wait(snapshot.docs.map((doc) async {
        CloudRecipe pescatarianRecipe = CloudRecipe.fromSnapshot(doc);
        pescatarianRecipe.imageSrc = await getImageUrl(pescatarianRecipe.imageSrc);
        return pescatarianRecipe;
      }));
      return allPescatarianRecipes;
    });
  }

  Future<String?> getImageUrl(String? imageName) async {
    try {
      String  downloadUrl = await storage.ref("recipe_images/$imageName").getDownloadURL();
      return downloadUrl;
    } catch(e) {
      DevTools.log("There was an error fetching the URL: $imageName");
      return null;
    }
  }
  RecipeStorage._sharedInstance();
  static final RecipeStorage _shared = RecipeStorage._sharedInstance();
  factory RecipeStorage() => _shared;
}