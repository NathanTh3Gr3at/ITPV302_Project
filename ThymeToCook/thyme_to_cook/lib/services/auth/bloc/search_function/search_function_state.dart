
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:thyme_to_cook/services/cloud/cloud_recipe.dart';

@immutable
abstract class SearchState {}
class SearchInitial extends SearchState{}
class SearchLoading extends SearchState{}

class SearchLoaded extends SearchState with EquatableMixin{
  final List<CloudRecipe?> recipes;
  SearchLoaded(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class SearchError extends SearchState{
  final String errorMessage;
  SearchError(this.errorMessage);
}

// for recipe detail 
class SearchRecipeDetail extends SearchState {
  final CloudRecipe recipe;
  SearchRecipeDetail(this.recipe);
}
