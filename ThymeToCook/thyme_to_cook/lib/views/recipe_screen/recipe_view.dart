import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class RecipeView extends StatefulWidget {
  final CloudRecipe recipe;
  const RecipeView({super.key, required this.recipe});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            widget.recipe.recipeName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: _recipePage(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Column _recipePage() {
    return Column(
      children: [
        _imageArea(),
        const SizedBox(
          height: 10,
        ),
        _instructions(),
      ],
    );
  }

  Container _imageArea() {
    final recipeImage = widget.recipe.imageUrl;
    return Container(
      width: 320,
      height: 225,
      decoration: BoxDecoration(
        image: recipeImage != null && recipeImage.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(recipeImage),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/placeholder_image.jpg'),
              ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Column _instructions() {
    return Column(
      children: [
        Column(
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // tab sections
                  const TabBar(
                    tabs: [
                      Tab(
                        child: Text("Ingredients"),
                      ),
                      Tab(
                        child: Text("Instructions"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    child: TabBarView(
                      // text under each tab
                      children: [
                        Card(
                          color: backgroundColor,
                          // color: Color.fromARGB(255, 252, 253, 242),
                          // elevation: 5,
                          child: Center(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final ingredients =
                                    widget.recipe.recipeIngredients[index];
                                return ListTile(
                                  title: Text(
                                    ('${ingredients.ingredientName} ${ingredients.quantity} ${ingredients.unit}'),
                                    // widget.recipe.recipeIngredients[index].toString(),
                                  ),
                                );
                              },
                              itemCount: widget.recipe.recipeIngredients.length,
                            ),
                          ),
                        ),
                        Card(
                          color: backgroundColor,
                          child: Center(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final instructions =
                                    widget.recipe.recipeInstructions[index];
                                return ListTile(
                                  title: Text(
                                    '$instructions',
                                  ),
                                );
                              },
                              itemCount:
                                  widget.recipe.recipeInstructions.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
