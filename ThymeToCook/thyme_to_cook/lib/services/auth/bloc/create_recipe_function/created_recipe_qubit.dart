import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class CreateRecipeQubit extends Cubit<List<CloudRecipe>> {
  CreateRecipeQubit() : super([]);

  void addRecipe(CloudRecipe recipe) {
    emit([...state, recipe]);
  }

  void removeRecipe(String recipeId) {
    emit(state.where((recipe) => recipe.recipeId != recipeId).toList());
  }
}
