import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class HeartIconButton extends StatelessWidget {
  final String recipeId;
  final CloudRecipe recipe;
  const HeartIconButton(
      {super.key,
      required this.recipeId,
      required this.recipe});

  @override
  Widget build(BuildContext context) {
    final saveRecipeCubit = context.read<SaveRecipeCubit>();
    final isLiked = saveRecipeCubit.isRecipeLiked(recipe.recipeId);

    return IconButton(
      onPressed: () {
        if (isLiked) {
          saveRecipeCubit.unlike(recipe.recipeId);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("${recipe.recipeName} was removed from your saved list"),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  context.read<SaveRecipeCubit>().likeRecipe(recipe);
                },
              ),
            ),
          );
        } else {
          saveRecipeCubit.likeRecipe(recipe);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("${recipe.recipeName} was added to your saved list"),
              // duration: const Duration(seconds: 3),
              // action: SnackBarAction(
              //   label: 'Undo',
              //   onPressed: () {
              //     context.read<SaveRecipeCubit>().unlike(recipe.recipeId);
              //   },
              // ),
            ),
          );
        }
      },
      icon: Icon(
        isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
