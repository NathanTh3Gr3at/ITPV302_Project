import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserData({required this.userId});

  Future<void> saveRecipeToCollection(String recipeId, String collectionName) async {
    final collectionDocRef = _firestore.collection('users').doc(userId).collection('collections').doc(collectionName);

    await collectionDocRef.set({
      'recipes': FieldValue.arrayUnion([recipeId])
    }, SetOptions(merge: true));
  }

  Future<void> removeRecipeFromCollection(String recipeId, String collectionName) async {
    final collectionDocRef = _firestore.collection('users').doc(userId).collection('collections').doc(collectionName);

    await collectionDocRef.update({
      'recipes': FieldValue.arrayRemove([recipeId])
    });
  }

  Future<bool> isRecipeSaved(String recipeId, String collectionName) async {
    final collectionDocRef = _firestore.collection('users').doc(userId).collection('collections').doc(collectionName);
    final doc = await collectionDocRef.get();

    if (doc.exists) {
      final recipes = List<String>.from(doc['recipes'] ?? []);
      return recipes.contains(recipeId);
    }
    return false;
  }
}
