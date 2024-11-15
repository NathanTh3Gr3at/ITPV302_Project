import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/meal_planner_function/meal_planner_cubit.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';

class RecipeSelectionPopup extends StatefulWidget {
  final String mealType;
  final String day;

  const RecipeSelectionPopup({super.key, required this.mealType, required this.day});

  @override
  State<RecipeSelectionPopup> createState() => _RecipeSelectionPopupState();
}

class _RecipeSelectionPopupState extends State<RecipeSelectionPopup> {
  final Set<CloudRecipe> _selectedRecipes = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Recipes"),
      content: BlocBuilder<SaveRecipeCubit, List<CloudRecipe>>(
        builder: (context, savedRecipes) {
          if (savedRecipes.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("No saved recipes"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdjustedSearchView(),
                      ),
                    );
                  },
                  child: const Text("Save Recipes"),
                ),
              ],
            );
          } else {
            return Container(
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: savedRecipes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1.2,
                ),
                itemBuilder: (context, index) {
                  CloudRecipe recipe = savedRecipes[index];
                  bool isSelected = _selectedRecipes.contains(recipe);
                  String imageUrl = "";
                  if (recipe.identifier == "kaggle") {
                    imageUrl = recipe.imageSrc!;
                  } else {
                    imageUrl = recipe.imageUrl!;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedRecipes.remove(recipe);
                        } else {
                          _selectedRecipes.add(recipe);
                        }
                      });
                    },
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: Stack(
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                height: double.infinity,
                                width: double.infinity,
                                child: const Center(
                                  child: Text('Image not found'),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              color: Colors.black.withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  recipe.recipeName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<MealPlannerCubit>().addRecipes(_selectedRecipes.toList(), widget.day, widget.mealType);
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
