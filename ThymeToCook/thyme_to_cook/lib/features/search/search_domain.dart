import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

abstract class SearchRepo {
  Future<List<CloudRecipe?>> searchRecipes(String query);
}

class FirebaseSearch implements SearchRepo {
  FirebaseSearch._singleton();
  // made a singleton
  static final FirebaseSearch _instance = FirebaseSearch._singleton();
  factory FirebaseSearch() => _instance;

  @override
  Future<List<CloudRecipe?>> searchRecipes(String query) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('recipes')
          // .where('recipe_ingredient', isGreaterThanOrEqualTo: query)
          .where('recipe_name',
              isGreaterThanOrEqualTo:
                  query) // ensures firestore returns recipe_name that starts with provided string
          .where('recipe_name',
              isLessThanOrEqualTo:
                  '$query\uf8ff') // expands search range by using prefix of query
          // limits queries to 12
          .limit(12)
          // .where('recipe_name', isEqualTo: query)
          .get();

      // maps each document to result and returns as list
      return result.docs.map((doc) {
        // final data = doc.data() as Map<String, dynamic>; // doc is removed as it is of type QueryDocument
        // print("$data");   // debug
        return CloudRecipe.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } catch (e) {
      throw Exception("Error searching recipes: $e ");
    }
  }
}
