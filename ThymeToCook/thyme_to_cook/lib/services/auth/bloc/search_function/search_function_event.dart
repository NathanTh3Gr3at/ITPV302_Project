import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';


abstract class SearchFunctionEvent extends Equatable {
  const SearchFunctionEvent();
  @override
  List<Object> get props => [];
}

class SearchTextChanged extends SearchFunctionEvent {
  final String searchText;

  const SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class SearchWithFilters extends SearchFunctionEvent {
  final String searchText;
  final List<String>? diets;
  final List<String>? ingredients;
  final List<String>? mealTypes;
  final List<String>? ratings;
  final List<String>? prepTimes;
  final List<String>? cookingTimes;
  final List<String>? totalTimes;
  final List<String>? health;

  const SearchWithFilters({
    required this.searchText,
    this.diets,
    this.ingredients,
    this.mealTypes,
    this.ratings,
    this.prepTimes,
    this.cookingTimes,
    this.totalTimes,
    this.health,
  });
}


// @immutable
// abstract class SearchFunctionEvent {
//   const SearchFunctionEvent();
// }

// // event when user types in search bar
// class SelectSearchEvent extends SearchFunctionEvent {
//   final String search;
//   const SelectSearchEvent(this.search);


// }

// class SearchEventInitial extends SearchFunctionEvent {
//   final String search;
//   const SearchEventInitial(this.search);
// }

// class SearchEventLoading extends SearchFunctionEvent {
//   final String recipes;
//   const SearchEventLoading({required this.recipes});

// }

// // for going to recipe detail screen
// class RecipeDetailEvent extends SearchFunctionEvent {
//   final CloudRecipe recipe;
//   const RecipeDetailEvent({required this.recipe});
  
// }

