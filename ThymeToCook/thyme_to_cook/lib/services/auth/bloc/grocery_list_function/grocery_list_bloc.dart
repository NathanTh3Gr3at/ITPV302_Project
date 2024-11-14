import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_state.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  GroceryListBloc() : super(GroceryListInitial()) {
    // initializes the grocery list
    on<GroceryListInitialize>((event, emit) {
      emit(GroceryListInitial());
    });

    // loads ingredients for specific recipe
    on<GroceryListLoadEvent>((event, emit) async {
      // emit(GroceryListLoading()); // emit loading causes an error where recipes were overriten

      try {
        final recipes = state is GroceryListLoaded
            ? List<GroceryList>.from((state as GroceryListLoaded).recipes)
            : <GroceryList>[];

        final existingRecipe = recipes.indexWhere((recipe) => recipe.recipeName == event.recipeName);

        if(existingRecipe != -1) {
          emit(GroceryListError("Recipe already added to you grocery list"));
        }

        else {

        // adding recipes to list
        recipes.add(GroceryList(
          recipeName: event.recipeName,
          recipeIngredients: event.ingredients,
          imageUrl: event.imageUrl
        ));
      }
        // ?List<Ingredient>.from((state as GroceryListLoaded).ingredients)
        // :<Ingredient>[];
        //   ingredients.addAll(event.ingredients);
        //   print("GroceryList loaded with recipe: ${event.recipeName}");

        emit(GroceryListLoaded(
          recipes: recipes,
        ));
      } catch (e) {
        emit(GroceryListError("Failed to load ingredients"));
        // for debugging
        //print(e);
      }
    });

    // handles toggling of ingredient status
    on<GroceryListToggleStatusEvent>((event, emit) async {
      final currentState = state;

      if (currentState is GroceryListLoaded) {
        final updateRecipe = List<GroceryList>.from(currentState.recipes);
        final recipe = updateRecipe[event.recipeIndex];
        final updateIngredient =
            List<RecipeIngredient>.from(recipe.recipeIngredients);
            // List<Ingredient>.from(recipe.recipeIngredients);
        final ingredient = updateIngredient[event.ingredientIndex];

        updateIngredient[event.ingredientIndex] =
            ingredient.copyWith(isChecked: !ingredient.isChecked);

        updateRecipe[event.recipeIndex] = GroceryList(
          recipeName: recipe.recipeName,
          recipeIngredients: updateIngredient,
          imageUrl: recipe.imageUrl
        );

        emit(GroceryListLoaded(recipes: updateRecipe
            // recipeName: currentState.recipeName,
            // ingredients: updateIngredient,
            ));
      }
    });

    // handles removing recipes
    on<GroceryListRemoveEvent>((event, emit) {
      if (state is GroceryListLoaded) {
        final updateRecipe =
            List<GroceryList>.from((state as GroceryListLoaded).recipes)
              ..removeAt(event.recipeIndex);
        emit(GroceryListLoaded(recipes: updateRecipe));
      }
    });
  }
}
