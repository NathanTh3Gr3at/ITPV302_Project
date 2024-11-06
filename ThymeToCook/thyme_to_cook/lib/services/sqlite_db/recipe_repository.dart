import 'package:thyme_to_cook/services/sqlite_db/database_helper.dart';
import 'package:thyme_to_cook/services/sqlite_db/db_recipe.dart';
import 'package:thyme_to_cook/services/sqlite_db/db_recipe_ingredient.dart';

class RecipeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  //insert a recipe and its ingredients
  Future<void> insertRecipe(DbRecipe recipe) async {
    final db = await _dbHelper.database;
    //insert the recipe
    await db.insert('recipes', recipe.toMap());
    // Insert each ingredient
    for (var ingredient in recipe.recipeIngredients) {
      await db.insert('ingredients', ingredient.toMap(recipe.recipeId));
    }
  }

  // Fetch recipes with ingredients
  Future<List<DbRecipe>> fetchRecipes({int limit = 20}) async {
    final db = await _dbHelper.database;
    final recipeMaps = await db.query('recipes', limit: limit);

    List<DbRecipe> recipes = [];

    for (var recipeMap in recipeMaps) {
      final ingredientMaps = await db.query(
        'ingredients',
        where: 'recipeId = ?',
        whereArgs: [recipeMap['recipeId']],
      );
      List<DbRecipeIngredient> ingredients =
          ingredientMaps.map((i) => DbRecipeIngredient.fromMap(i)).toList();

      recipes.add(DbRecipe.fromMap(recipeMap, ingredients));
    }

    return recipes;
  }

  //update a recipe
  Future<void> updateRecipe(DbRecipe recipe) async {
    final db = await _dbHelper.database;

    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'recipeId = ?',
      whereArgs: [recipe.recipeId],
    );

    // Delete old ingredients and add the updated ones
    await db.delete('ingredients',
        where: 'recipeId = ?', whereArgs: [recipe.recipeId]);
    for (var ingredient in recipe.recipeIngredients) {
      await db.insert('ingredients', ingredient.toMap(recipe.recipeId));
    }
  }

  // Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    final db = await _dbHelper.database;
    await db.delete('recipes', where: 'recipeId = ?', whereArgs: [recipeId]);
    await db
        .delete('ingredients', where: 'recipeId = ?', whereArgs: [recipeId]);
  }
}
