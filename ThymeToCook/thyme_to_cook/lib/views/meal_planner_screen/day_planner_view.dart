import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/auth/bloc/meal_planner_function/meal_planner_cubit.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/meal_planner_screen/recipe_selection_popup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class DayPlannerView extends StatefulWidget {
  final String day;

  const DayPlannerView({super.key, required this.day});

  @override
  State<DayPlannerView> createState() => _DayPlannerViewState();
}

class _DayPlannerViewState extends State<DayPlannerView> {
  Map<String, List<CloudRecipe>> _mealPlans = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Dessert': [],
  };

  @override
  void initState() {
    super.initState();
    _mealPlans = context.read<MealPlannerCubit>().state[widget.day] ?? {
      'Breakfast': [],
      'Lunch': [],
      'Dinner': [],
      'Dessert': [],
    };
  }

  void _showRecipeSelection(BuildContext context, String mealType) {
    showDialog(
      context: context,
      builder: (context) {
        return RecipeSelectionPopup(mealType: mealType, day: widget.day);
      },
    ).then((_) {
      setState(() {
        _mealPlans = context.read<MealPlannerCubit>().state[widget.day] ?? {
          'Breakfast': [],
          'Lunch': [],
          'Dinner': [],
          'Dessert': [],
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "${widget.day} Planner",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            MdiIcons.chevronLeft,
          ),
          iconSize: 35,
        ),
        leadingWidth: 40,
      ),
      body: BlocBuilder<MealPlannerCubit, Map<String, Map<String, List<CloudRecipe>>>>(
        builder: (context, mealPlans) {
          _mealPlans = mealPlans[widget.day] ?? _mealPlans;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  _buildMealTypeTile('Breakfast'),
                  _buildMealTypeTile('Lunch'),
                  _buildMealTypeTile('Dinner'),
                  _buildMealTypeTile('Dessert'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealTypeTile(String mealType) {
    List<CloudRecipe>? mealPlans = _mealPlans[mealType] ?? [];

    return Column(
      children: [
        ListTile(
          title: Text(mealType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          trailing: Icon(MdiIcons.plus),
          onTap: () {
            _showRecipeSelection(context, mealType);
          },
        ),
        if (mealPlans.isNotEmpty)
          SizedBox(
            height: 150, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mealPlans.length,
              itemBuilder: (context, index) {
                CloudRecipe recipe = mealPlans[index];
                return _buildRecipeCard(recipe, mealType, widget.day);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecipeCard(CloudRecipe recipe, String mealType, String day) {
    String imageUrl = "";
    if (recipe.identifier == "kaggle") {
      imageUrl = recipe.imageSrc!;
    } else {
      imageUrl = recipe.imageUrl!;
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: backgroundColor, 
      child: Stack(
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
            child: Container(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // Curved edges for the image
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Text('Image not found'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      mealType,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
          top: 2,
          right: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: const Color.fromARGB(255, 170, 127, 124)),
              onPressed: () {
                context.read<MealPlannerCubit>().removeRecipe(recipe.recipeId, day, mealType);
              },
            ),
          ),
        ),
        ],
      ),
    );
  }
}
