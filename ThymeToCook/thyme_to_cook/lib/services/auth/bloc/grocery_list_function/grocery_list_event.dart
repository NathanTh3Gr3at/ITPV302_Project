import 'package:equatable/equatable.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

abstract class GroceryListEvent extends Equatable {
  const GroceryListEvent();
}

class GroceryListInitialize extends GroceryListEvent {
  const GroceryListInitialize();

  @override
  List<Object> get props => [];
}

// Adding to grocery list
class GroceryListLoadEvent extends GroceryListEvent {
  final String recipeName;
  final List<RecipeIngredient> ingredients;

  const GroceryListLoadEvent({required this.recipeName, required this.ingredients});

  @override
  List<Object> get props => [recipeName, ingredients];
}

// Toggles status of ingredients in list
class GroceryListToggleStatusEvent extends GroceryListEvent {
  final int recipeIndex;
  final int ingredientIndex;

  const GroceryListToggleStatusEvent({required this.recipeIndex, required this.ingredientIndex});

  @override
  List<Object> get props => [recipeIndex, ingredientIndex];
}


class GroceryListRemoveEvent extends GroceryListEvent {
  final int recipeIndex;

  const GroceryListRemoveEvent({required this.recipeIndex});

  @override 
  List<Object> get props => [recipeIndex];

}