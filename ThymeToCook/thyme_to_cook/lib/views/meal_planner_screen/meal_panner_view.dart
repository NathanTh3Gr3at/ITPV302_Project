import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/meal_planner_screen/day_planner_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/auth/bloc/meal_planner_function/meal_planner_cubit.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  DateTime _selectedDate = DateTime.now(); // Start with the current date.

  // Function to format date range as "Sun, Oct 6 - Sat, Oct 12"
  String getFormattedDateRange(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    String start = DateFormat('EEE, MMM d').format(startOfWeek);
    String end = DateFormat('EEE, MMM d').format(endOfWeek);
    return "$start - $end";
  }

  // Function to go to the previous week
  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    });
  }

  // Function to go to the next week
  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    });
  }

  // Function to get the week number of the year
  int getWeekNumber(DateTime date) {
    final beginningOfYear = DateTime(date.year, 1, 1);
    final daysSinceNewYear = date.difference(beginningOfYear).inDays;
    return (daysSinceNewYear / 7).ceil();
  }

  // Function to check if the selected date is this week
  bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    return getWeekNumber(date) == getWeekNumber(now) && date.year == now.year;
  }

  // Function to check if the selected date is next week
  bool isNextWeek(DateTime date) {
    final nextWeek = DateTime.now().add(const Duration(days: 7));
    return getWeekNumber(date) == getWeekNumber(nextWeek) && date.year == nextWeek.year;
  }

  // Function to check if the selected date is last week
  bool isLastWeek(DateTime date) {
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    return getWeekNumber(date) == getWeekNumber(lastWeek) && date.year == lastWeek.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Meal Planner',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(MdiIcons.chevronLeft),
                onPressed: _goToPreviousWeek,
              ),
              Text(
                isThisWeek(_selectedDate)
                    ? 'This Week'
                    : isNextWeek(_selectedDate)
                        ? 'Next Week'
                        : isLastWeek(_selectedDate)
                            ? 'Last Week'
                            : getFormattedDateRange(_selectedDate),
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(MdiIcons.chevronRight),
                onPressed: _goToNextWeek,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: BlocBuilder<MealPlannerCubit, Map<String, Map<String, List<CloudRecipe>>>>(
          builder: (context, mealPlans) {
            return ListView(
              children: [
                _dayTile("Sunday", mealPlans["Sunday"]),
                _dayTile("Monday", mealPlans["Monday"]),
                _dayTile("Tuesday", mealPlans["Tuesday"]),
                _dayTile("Wednesday", mealPlans["Wednesday"]),
                _dayTile("Thursday", mealPlans["Thursday"]),
                _dayTile("Friday", mealPlans["Friday"]),
                _dayTile("Saturday", mealPlans["Saturday"]),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _dayTile(String day, Map<String, List<CloudRecipe>>? dayMealPlans) {
    return ExpansionTile(
      title: Text(day),
      trailing: IconButton(
        icon: Icon(MdiIcons.chevronRight),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResponsiveWrapper.builder(
                DayPlannerView(day: day),
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
      ),
      children: [
        if (dayMealPlans != null)
          SizedBox(
            height: 150, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dayMealPlans.values.expand((list) => list).length,
              itemBuilder: (context, index) {
                final recipe = dayMealPlans.values.expand((list) => list).toList()[index];
                final mealType = dayMealPlans.entries.firstWhere((entry) => entry.value.contains(recipe)).key;
                return _buildRecipeCard(recipe, mealType, day);
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
              icon: const Icon(Icons.close, color: Color.fromARGB(255, 170, 127, 124)),
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
