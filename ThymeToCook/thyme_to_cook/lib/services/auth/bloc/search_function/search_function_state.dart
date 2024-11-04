
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();
  @override 
  List<Object> get props => [];
}
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final List<CloudRecipe> recipes;
  const SearchSuccess(this.recipes);
  @override 
  List<Object> get props => [recipes];
}
class SearchError extends SearchState{
  final String errorMessage;
  const SearchError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}


// class SearchLoaded extends SearchState with EquatableMixin{
//   final List<CloudRecipe?> recipes;
//   SearchLoaded(this.recipes);

//   @override
//   List<Object?> get props => [recipes];
// }


// // for recipe detail 
// class SearchRecipeDetail extends SearchState {
//   final CloudRecipe recipe;
//   SearchRecipeDetail(this.recipe);
// }
