import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/features/search/search_domain.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_state.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class SearchBloc extends Bloc<SearchFunctionEvent, SearchState> {
  // creates instance of FirebaseSearch from search_domain
  final SearchRepo searchRepo = FirebaseSearch(); 

  SearchBloc() : super(SearchInitial()) {
    on<SelectSearchEvent>((event, emit) async {
      final query = event.search;
      if (query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      try {
        emit(SearchLoading()); // emit loading state when search starts
        final List<CloudRecipe?> recipes =
            await searchRepo.searchRecipes(query);
        final List<CloudRecipe> validRecipes = recipes
            .where((recipe) => recipe != null)
            .cast<CloudRecipe>()
            .toList();
        if (recipes.isEmpty) {
          emit(SearchLoaded(const [])); // emit empty list if no results
        } else {
          emit(SearchLoaded(recipes)); // emit recipe results
        }
        emit(SearchLoaded(validRecipes));

        // for debugging
        // for (var recipe in recipes) {
        //   if (recipe != null) {
        //      print('Recipes fetched: $recipes.recipe_name');
        //   }
        // }
      } catch (e) {
        print('Error: $e');
        emit(SearchError("Error getting recipes"));
      }
    });

    // handles going to recipe detail
    on<RecipeDetailEvent>((event, emit) async {
      try {
        emit(SearchRecipeDetail(event.recipe));

      }catch (e) {
        emit(SearchError("Error going to recipe detail screen"));
      }
    });
  }
}
