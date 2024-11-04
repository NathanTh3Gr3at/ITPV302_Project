import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

@immutable
abstract class GroceryListState {}

// initial state of list 
class GroceryListInitial extends GroceryListState {}

// state for fetching recipes
class GroceryListLoading extends GroceryListState {}

// state when recipe is loaded 
class GroceryListLoaded extends GroceryListState with EquatableMixin {
  final List<GroceryList> recipes;

  GroceryListLoaded({required this.recipes});

  @override
  List<Object?> get props => [recipes];
}

class GroceryListError extends GroceryListState {
  final String errorMessage;
  GroceryListError(this.errorMessage);
}

