import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class SaveRecipeCubit extends Cubit<List<CloudRecipe>> {
  SaveRecipeCubit() : super([]);

  void likedInitializeRecipes(List<CloudRecipe> initialRecipes) {
    emit(initialRecipes);
  }

  // adds recipe to saved list
  void likeRecipe(CloudRecipe recipe) {
    
    if(!state.any((r) => r.recipeId == recipe.recipeId)) {
      final updateList = List<CloudRecipe>.from(state); 
      updateList.add(recipe);
      emit(updateList);
    // if(!state.contains(recipe)) {
    //   state.add(recipe);
    //   emit(List.from(state));
    // }
    // if(!isRecipeLiked(recipe.recipeId)) {
    //   final updatedList = List<CloudRecipe>.from(state)..add(recipe);
    //   emit(updatedList);

    // for debugging
    //  print("Liking recipe: ${recipe.recipeId}");
    //  print("Recipe list updated: ${updateList}");
    }
  }

  void unlike(String recipeId) {
     final updatedList = state.where((recipe) => recipe.recipeId != recipeId).toList();
     emit(updatedList);
    // for debugging
    // print("Recipe unliked: ${recipeId}");
    // print("Recipe list updated: ${updatedList}");
  } 

  bool isRecipeLiked(String recipeId) {
    return state.any((recipe) => recipe.recipeId == recipeId);
  }

  // void clearRecipes() {
  //   emit([]);
  // }

}