import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_state.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';

class GroceryListView extends StatefulWidget {
  const GroceryListView({super.key});

  @override
  State<GroceryListView> createState() => _GroceryListViewState();
}

class _GroceryListViewState extends State<GroceryListView> {
  late GroceryListBloc groceryBloc;
  final Map<int, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    groceryBloc = BlocProvider.of<GroceryListBloc>(context);
    // initialize grocery list
    // context.read<GroceryListBloc>().add(const GroceryListInitialize());
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;
    // if (_recipeName.isEmpty) {
    //   _recipeName = args['recipeName'] as String;
    //   final ingredients = args['ingredients'] as List<dynamic>;
    //   _initializeIngredients(ingredients.cast<Ingredient>());
    // }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  MdiIcons.chevronLeft,
                ),
                iconSize: 35,
              ),
              leadingWidth: 40,
        backgroundColor: backgroundColor,
        title: const Text(
          // _recipeName,
          'Grocery Lists',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Add functionality
            },
          ),
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.menu),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                  break;
                case MenuAction.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileView(),
                    ),
                  );
                  break;
                case MenuAction.settings:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile,
                  child: Text("User Profile"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text("Settings"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GroceryListBloc, GroceryListState>(
            builder: (context, state) {
              if (state is GroceryListLoaded) {
                
                if (state.recipes.isEmpty) {
                  return const Center(
                    child: Text("No groceries added"),
                  );
                }
                return _groceryListMethod(state.recipes);
              } else if (state is GroceryListError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }
              return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/sad_image.png'),
              height: 200, // Adjust height as needed
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "You have no grocery list, Search for recipes to add",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponsiveWrapper.builder(
                              const AdjustedSearchView(),
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
                      child: const Text('Search for recipes'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
            },
          )
          // ? const Center(child: Text('No ingredients to buy'))
          // : _groceryListMethod(),
          ),
      // bottomNavigationBar: const BottomNavBar(),
    );
  }

  ListView _groceryListMethod(List<GroceryList> recipes) {
  return ListView(
    children: recipes.map((recipe) {
      final recipeIndex = recipes.indexOf(recipe);
      _expandedStates.putIfAbsent(recipeIndex, () => false);

      return Dismissible(
        key: Key(recipe.recipeName),
        direction: DismissDirection.endToStart,
        background: Container(
          color: secondaryButtonColor,
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (direction) {
          context.read<GroceryListBloc>().add(
                GroceryListRemoveEvent(recipeIndex: recipeIndex),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${recipe.recipeName} was removed from grocery list"),
            ),
          );
        },

        child: ExpansionTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners for the image
            child: Image.network(
              recipe.imageUrl ?? '',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.image, color: Colors.white),
                );
              },
            ),
          ),
          title: Text(recipe.recipeName),
          trailing: Icon(
            _expandedStates[recipeIndex] == true
                ? Icons.restaurant_menu_rounded
                : Icons.restaurant_rounded,
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _expandedStates[recipeIndex] = expanded;
            });
          },
          children: recipe.recipeIngredients.map((ingredient) {
            final ingredientIndex = recipe.recipeIngredients.indexOf(ingredient);

            final convertedIngredient = ingredient.toIngredient();
            String formattedQuantity = ingredient.getQuantityAsFraction();

            return ListTile(
              title: Text(
                " $formattedQuantity  ${convertedIngredient.unit ?? ''} ${convertedIngredient.name}",
                style: TextStyle(
                  decoration: ingredient.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                  color: ingredient.isChecked ? Colors.grey : Colors.black,
                ),
              ),
              trailing: Icon(
                ingredient.isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                color: ingredient.isChecked ? Colors.green : Colors.grey,
              ),
              onTap: () => context.read<GroceryListBloc>().add(
                    GroceryListToggleStatusEvent(
                      recipeIndex: recipeIndex,
                      ingredientIndex: ingredientIndex,
                    ),
                  ),
            );
          }).toList(),
        ),
      );
    }).toList(),
  );
}

}
