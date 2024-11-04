import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/features/search/search_domain.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_state.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';

class SearchBloc extends Bloc<SearchFunctionEvent, SearchState> {
  // creates instance of FirebaseSearch from search_domain
  RecipeStorage recipeStorage;

  SearchBloc(this.recipeStorage) : super(SearchInitial()) {
    on<SearchTextChanged>((event, emit) async {
      final query = event.searchText;
      emit(SearchLoading());
      try {
        List<CloudRecipe> recipes;
        if (query.isEmpty) {
          recipes = await recipeStorage.fetchRecipes();
        } else {
          // If theres recipes emit them
          recipes = await recipeStorage.fetchRecipes(searchQuery: query);
        }
        emit(SearchSuccess(recipes));
      } catch(e) {
        // If an error occurs emit that as well 
        log("Error has occurred getting recipes");
        emit(const SearchError("Error getting recipes"));
      }
    }
    );
    on<SearchWithFilters>((event, emit) async {
      final query = event.searchText;
      emit(SearchLoading());
      try {
        List<CloudRecipe> recipes;
        recipes = await recipeStorage.fetchRecipes(
          searchQuery: query,
          diets: event.diets,
          ingredients: event.ingredients,
          mealTypes: event.mealTypes,
          ratings: event.ratings,
          prepTimes: event.prepTimes,
          cookingTimes: event.cookingTimes,
          totalTimes: event.totalTimes,
          health: event.health,
        );
        emit(SearchSuccess(recipes));
      } catch (e) {
        log("Error has occurred getting recipes: $e");
        emit(const SearchError("Error getting recipes"));
      }
    });
  }
}

//       try {
//         emit(SearchLoading()); // emit loading state when search starts
//         final List<CloudRecipe?> recipes =
//             await searchRepo.searchRecipes(query);
//         final List<CloudRecipe> validRecipes = recipes
//             .where((recipe) => recipe != null)
//             .cast<CloudRecipe>()
//             .toList();
//         if (recipes.isEmpty) {
//           emit(SearchLoaded(const [])); // emit empty list if no results
//         } else {
//           emit(SearchLoaded(recipes)); // emit recipe results
//         }
//         emit(SearchLoaded(validRecipes));

//         // for debugging
//         // for (var recipe in recipes) {
//         //   if (recipe != null) {
//         //      print('Recipes fetched: $recipes.recipe_name');
//         //   }
//         // }
//       } catch (e) {
//         print('Error: $e');
//         emit(SearchError("Error getting recipes"));
//       }
//     });

//     // handles going to recipe detail
//     on<RecipeDetailEvent>((event, emit) async {
//       try {
//         emit(SearchRecipeDetail(event.recipe));

//       }catch (e) {
//         emit(SearchError("Error going to recipe detail screen"));
//       }
//     });
//   }
// }
