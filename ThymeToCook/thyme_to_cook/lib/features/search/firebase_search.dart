// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:thyme_to_cook/features/search/search_domain.dart';
// import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

// class FirebaseSearch implements SearchRepo {
//   @override
//   Future<List<CloudRecipe>> searchRecipes(String query) async {
//     try {
//         final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('recipes')     
//         // .where('recipe_ingredient', isGreaterThanOrEqualTo: query)                                 
//         .where('recipe_name', isGreaterThanOrEqualTo: query)        // ensures firestore returns recipe_name that starts with provided string
//         .where('recipe_name', isLessThanOrEqualTo: '$query\uf8ff')  // expands search range by using prefix of query
//         // .where('recipe_name', isEqualTo: query)
//         .get();

//       // maps each document to result and returns as list
//       return result.docs
//       .map((doc) {  
//         final data = doc.data() as Map<String, dynamic>;
//         // print("$data");   // debug
//         return CloudRecipe.fromSnapshot(data as QueryDocumentSnapshot<Map<String, dynamic>>);
//       }).toList();  
//     }  
//     catch (e) {
//       throw Exception("Error searching recipes: $e ");

//     }
//   }
//   // final CloudRecipe? currentRecipe = FirebaseFirestore.instance.doc("recipes") as CloudRecipe?;
//   // Future<DocumentSnapshot<Map<String, dynamic>>> getRecipeDetails(String recipeName) async {
//   //   return await FirebaseFirestore.instance
//   //   .collection("recipes")
//   //   .doc(currentRecipe!.recipeName)
//   //   .get();
//   // }

// }