import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thyme_to_cook/services/auth/auth_user.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class AuthUserStorage {
  final FirebaseFirestore _dbInstance = FirebaseFirestore.instance;

  // Get the current user ID
  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("No user currently logged in");
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveRecipeToCollection(AuthUser authUser, String collection, String recipeId) async {
    try {
      await _firestore
          .collection('users')
          .doc(authUser.id)
          .collection(collection)
          .add({"recipe_id": recipeId});
    } catch (error) {
      throw Exception('Failed to save recipe: $error');
    }
  }

  

  Future<bool> isRecipeInCollection(AuthUser authUser, String collection, String recipeId) async {
    final querySnapshot = await _firestore.collection('users')
        .doc(authUser.id)
        .collection(collection)
        .where('recipeId', isEqualTo: recipeId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }


  Future<void> initializeUserCollections() async {
    String userId = getCurrentUserId();
    await _initializeCollection(userId, 'meal_planner');
    await _initializeCollection(userId, 'collections');
    await _initializeCollection(userId, 'grocery_list');
  }

  Future<void> _initializeCollection(String userId, String collectionName) async {
    CollectionReference collectionRef = _dbInstance.collection("users").doc(userId).collection(collectionName);
    DocumentSnapshot doc = await collectionRef.doc('init').get();

    if (!doc.exists) {
      await collectionRef.doc('init').set({'initialized': true});
    }
  }

  Future<String> getUsername() async {
    String userId = getCurrentUserId();
    DocumentSnapshot doc = await _dbInstance.collection("users").doc(userId).get();
    if (doc.exists) {
      return doc['username'];
    } else {
      throw Exception("User not found");
    }
  }

  // Method to create the user document
  Future<void> createUserDocument(Map<String, dynamic> userData) async {
    String userId = getCurrentUserId();
    await _dbInstance.collection("users").doc(userId).set(userData);
  }

  // Getting user data from the database
  Future<Map<String, dynamic>> getUserData() async {
    String userId = getCurrentUserId();
    DocumentSnapshot doc = await _dbInstance.collection("users").doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }

  // Updating the users data
  Future<void> updateUserDocument(Map<String, dynamic> userData) async {
    String userId = getCurrentUserId();
    await _dbInstance.collection("users").doc(userId).update(userData);
  }

  // Method to add a Recipe that the user created --> Accounting for future searching
  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    String userId = getCurrentUserId();
    recipe['recipe_name'] = recipe['recipe_name'].toString();
    recipe['search_keys'] = recipe['recipe_name'].toLowerCase().split(' ').map((e) => e.trim()).toList();
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('recipes').add(recipe);
  }

  // Method to get all the users created recipes --> Maybe later we'll try a stream??
  Future<List<Map<String, dynamic>>> getUserRecipes() async {
    String userId = getCurrentUserId();
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("recipes").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Method to add meal planner
  // Meal planner --> createDate, dayOfTheWeek, mealType
  Future<void> addMealPlanner(Map<String, dynamic> mealPlanner) async {
    String userId = getCurrentUserId();
    await _dbInstance.collection("users").doc(userId).collection("meal_planner").add(mealPlanner);
  }

  // Method to get all meal planner data
  Future<List<Map<String, dynamic>>> getAllMealPlanners() async {
    String userId = getCurrentUserId();
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("meal_planner").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Method to remove a meal planner
  Future<void> removeMealPlanner(Map<String, dynamic> mealPlanner) async {
    String userId = getCurrentUserId();
    QuerySnapshot snapshot = await _dbInstance
        .collection("users")
        .doc(userId)
        .collection("meal_planner")
        .where("dayOfWeek", isEqualTo: mealPlanner['dayOfWeek'])
        .where("mealType", isEqualTo: mealPlanner['mealType'])
        .where("recipeName", isEqualTo: mealPlanner['recipeName'])
        .get();

    for (var doc in snapshot.docs) {
      await _dbInstance.collection("users").doc(userId).collection("meal_planner").doc(doc.id).delete();
    }
  }

  // Method to add collections
  Future<void> addCollection(Map<String, dynamic> mealPlanner) async {
    String userId = getCurrentUserId();
    await _dbInstance.collection("users").doc(userId).collection("collections").add(mealPlanner);
  }

  // Method to get all collection data
  Future<List<Map<String, dynamic>>> getAllCollections() async {
    String userId = getCurrentUserId();
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("collections").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Method to add grocery list
  Future<void> addGroceryList(Map<String, dynamic> mealPlanner) async {
    String userId = getCurrentUserId();
    await _dbInstance.collection("users").doc(userId).collection("grocery_list").add(mealPlanner);
  }

  // Method to get all grocery list data
  Future<List<Map<String, dynamic>>> getAllGroceryLists() async {
    String userId = getCurrentUserId();
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("grocery_list").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // // Method to get UserData instance
  // UserData getUserDataInstance() {
  //   String userId = getCurrentUserId();
  //   return UserData(userId: userId);
  // }

  Future<List<String>> fetchRecipeNamesForCollection(String userId, String collectionName) async {
    final querySnapshot = await _firestore.collection('users')
        .doc(userId)
        .collection(collectionName)
        .get();

    final recipeNames = querySnapshot.docs
        .where((doc) => doc.data().containsKey('recipeName'))
        .map((doc) => doc['recipeName'] as String)
        .toList();

    log('Retrieved recipe names from $collectionName: $recipeNames'); // Logging the recipe names

    return recipeNames;
  }

  Future<CloudRecipe> fetchRecipeByName(String recipeName) async {
    log('Fetching recipe by name: $recipeName'); // Log the recipe name being fetched

    final querySnapshot = await _firestore.collection('recipes')
        .where('recipe_name', isEqualTo: recipeName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      log('Recipe found: ${querySnapshot.docs.first.data()}'); // Log the fetched recipe
      return CloudRecipe.fromSnapshot(querySnapshot.docs.first);
    } else {
      log('No recipe found with name: $recipeName'); // Log when no recipe is found
      throw Exception('Recipe not found');
    }
  }

  Future<void> removeRecipeFromCollection(AuthUser authUser, String collection, String recipeId) async {
    final querySnapshot = await _firestore.collection('users')
        .doc(authUser.id)
        .collection(collection)
        .where('recipe_name', isEqualTo: recipeId)
        .get();

    for (var doc in querySnapshot.docs) {
      await _firestore.collection('users')
          .doc(authUser.id)
          .collection(collection)
          .doc(doc.id)
          .delete();
    }
  }
  Future<List<String>> getSavedRecipeIds(AuthUser authUser, String collection) async {
    final querySnapshot = await _firestore.collection('users')
        .doc(authUser.id)
        .collection(collection)
        .get();

    List<String> recipeIds = [];
    for (var doc in querySnapshot.docs) {
      recipeIds.add(doc['recipe_name'] as String);
    }

    return recipeIds;
  }


}




