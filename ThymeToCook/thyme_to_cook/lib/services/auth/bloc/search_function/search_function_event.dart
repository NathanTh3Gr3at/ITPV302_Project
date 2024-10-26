import 'package:flutter/foundation.dart' show immutable;
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

@immutable
abstract class SearchFunctionEvent {
  const SearchFunctionEvent();
}

// event when user types in search bar
class SelectSearchEvent extends SearchFunctionEvent {
  final String search;
  const SelectSearchEvent(this.search);


}

class SearchEventInitial extends SearchFunctionEvent {
  final String search;
  const SearchEventInitial(this.search);
}

class SearchEventLoading extends SearchFunctionEvent {
  final String recipes;
  const SearchEventLoading({required this.recipes});

}

// for going to recipe detail screen
class RecipeDetailEvent extends SearchFunctionEvent {
  final CloudRecipe recipe;
  const RecipeDetailEvent({required this.recipe});
  
}

