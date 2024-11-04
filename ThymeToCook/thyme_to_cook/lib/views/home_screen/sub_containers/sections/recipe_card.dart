import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class RecipeCard extends StatelessWidget {
  final CloudRecipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    String? imageUrl = recipe.identifier == "kaggle" ? recipe.imageSrc : recipe.imageUrl;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResponsiveWrapper.builder(
                      RecipeView(recipe: recipe),
                      breakpoints: const [
                        ResponsiveBreakpoint.resize(480, name: MOBILE),
                        ResponsiveBreakpoint.resize(800, name: TABLET),
                        ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                        ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                      ],
                    ),
                  ),
                );
              },
              child: Image.network(
                imageUrl ?? "",
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    color: Colors.grey,
                    child: const Center(child: Text('Image not found')),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.recipeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(MdiIcons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text(recipe.rating?.toString() ?? 'N/A', style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      Icon(MdiIcons.fire, color: Colors.red, size: 16),
                      const SizedBox(width: 5),
                      Text(recipe.calories?.toString() ?? 'N/A', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(MdiIcons.clock, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(recipe.totalTime?.toString() ?? 'N/A', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
