
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

abstract class SearchRepo {
  Future<List<CloudRecipe?>> searchRecipes(String query);
}