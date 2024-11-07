import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class MealPlannerCubit extends Cubit<Map<String, Map<String, List<CloudRecipe>>>> {
  MealPlannerCubit() : super({
    'Sunday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
    'Monday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
    'Tuesday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
    'Wednesday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
    'Thursday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
    'Friday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
    'Saturday': {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Dessert': []},
  });

  // Add multiple recipes to the specified day and meal type
  void addRecipes(List<CloudRecipe> recipes, String day, String mealType) {
    final updatedMealPlans = Map<String, Map<String, List<CloudRecipe>>>.from(state);
    updatedMealPlans[day]![mealType] = [
      ...updatedMealPlans[day]![mealType]!,
      ...recipes,
    ];
    emit(updatedMealPlans);
  }

  // Remove a recipe from the specified day and meal type
  void removeRecipe(String recipeId, String day, String mealType) {
    final updatedMealPlans = Map<String, Map<String, List<CloudRecipe>>>.from(state);
    updatedMealPlans[day]![mealType] = updatedMealPlans[day]![mealType]!
        .where((recipe) => recipe.recipeId != recipeId)
        .toList();
    emit(updatedMealPlans);
  }

  // Clear all recipes for the specified day and meal type
  void clearRecipes(String day, String mealType) {
    final updatedMealPlans = Map<String, Map<String, List<CloudRecipe>>>.from(state);
    updatedMealPlans[day]![mealType] = [];
    emit(updatedMealPlans);
  }
}
