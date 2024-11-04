import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUserStorage {
  final FirebaseFirestore _dbInstance = FirebaseFirestore.instance;
  // Method to create the user document
  Future<void> createUserDocument(String userId, Map<String, dynamic> userData) async {
    await _dbInstance.collection("users").doc(userId).set(userData);
  }
  // Getting user data from the database 
  Future<Map<String, dynamic>> getUserData (String userId) async {
    DocumentSnapshot doc = await _dbInstance.collection("users").doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }
  // Updating the users data 
  Future<void> updateUserDocument(String userId, Map<String, dynamic> userData) async {
    await _dbInstance.collection("users").doc(userId).update(userData);
  }
  // Method to add a Recipe that the user created --> Accounting for future searching
  Future<void> addRecipe(String userId, Map<String, dynamic> recipe) async {
  recipe['recipe_name'] = recipe['recipe_name'].toString();
  recipe['search_keys'] = recipe['recipe_name'].toLowerCase().split(' ').map((e) => e.trim()).toList();
  await FirebaseFirestore.instance.collection('users').doc(userId).collection('recipes').add(recipe);
}
  // Future<void> addRecipe(String userId, Map<String, dynamic> recipe) async {
  //   await _dbInstance.collection("users").doc(userId).collection("recipes").add(recipe);
  // }
  // Method to get all the users created recipes --> Maybe later we'll try a stream??
  Future<List<Map<String, dynamic>>> getUserRecipes(String userId) async {
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("recipes").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  // Method to add meal planner 
  // Meal planner --> createDate, dayOfTheWeek, mealType
  Future<void> addMealPlanner (String userId, Map<String, dynamic> mealPlanner) async {
    await _dbInstance.collection("users").doc(userId).collection("meal_planner").add(mealPlanner);
  }
  // Method to get all meal planner data 
  Future<List<Map<String, dynamic>>> getAllMealPlanners(String userId) async {
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("meal_planner").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  // mETHOD TO add collections
  Future<void> addCollection (String userId, Map<String, dynamic> mealPlanner) async {
    await _dbInstance.collection("users").doc(userId).collection("collections").add(mealPlanner);
  }
  // Method to get all collection data 
  Future<List<Map<String, dynamic>>> getAllCollections(String userId) async {
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("collections").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  // Method to add grocery list 
  Future<void> addGroceryList (String userId, Map<String, dynamic> mealPlanner) async {
    await _dbInstance.collection("users").doc(userId).collection("grocery_list").add(mealPlanner);
  }
  // Method to get all grocery list data 
  Future<List<Map<String, dynamic>>> getAllGroceryLists (String userId) async {
    QuerySnapshot snapshot = await _dbInstance.collection("users").doc(userId).collection("grocery_list").get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}