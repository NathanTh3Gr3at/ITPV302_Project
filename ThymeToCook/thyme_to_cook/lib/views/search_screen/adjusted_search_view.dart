import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_state.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';
import 'package:thyme_to_cook/views/search_screen/filter_stuff/filter_button.dart';
import 'package:thyme_to_cook/views/search_screen/filter_stuff/filter_option.dart';
import 'package:thyme_to_cook/views/search_screen/filter_stuff/more_ingredients_screen.dart';

class AdjustedSearchView extends StatefulWidget {
  const AdjustedSearchView({super.key});

  @override
  State<AdjustedSearchView> createState() => _AdjustedSearchViewState();
}

class _AdjustedSearchViewState extends State<AdjustedSearchView> with WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();
  final ScrollController modalController = ScrollController();
  late SearchBloc searchBloc;
  int currentPage = 0;
  int pageSize = 10;
  late TextEditingController _searchController;
  Set<String> selectedFilter = {};
  RecipeStorage? _recipeStorage;
  String searchQuery = '';
  DocumentSnapshot? lastDocument;
  bool showClearTextButton = false;
  List<String>? selectedDiets = [];
  List<String>? selectedIngredients = [];
  List<String>? selectedMealTypes = [];
  List<String>? selectedPrepTimes = [];
  List<String>? selectedCookingTimes = [];
  List<String>? selectedRatings = [];
  List<String>? selectedTotalTimes = [];
  List<String>? selectedHeath = [];
  int selectedDietCount = 0;
  int selectedIngredientCount = 0;
  // int selectedNutritionCount = 0;
  int selectedPrepTimeCount = 0;
  int selectedCookingTimeCount = 0;
  int selectedTotalTimeCount = 0;
  int selectedRatingCount = 0;
  int selectedMealTypeCount = 0;
  int selectedHealthCount = 0;
  int pageIndex = 0;
  late FocusNode _focusNode;
  bool _keyboardVisible = false;

  void clearFilters() {
    setState(() {
      selectedDiets = [];
      selectedIngredients = [];
      selectedMealTypes = [];
      selectedPrepTimes = [];
      selectedCookingTimes = [];
      selectedRatings = [];
      selectedTotalTimes = [];
      selectedHeath = [];
      selectedDietCount = 0;
      selectedIngredientCount = 0;
      selectedPrepTimeCount = 0;
      selectedCookingTimeCount = 0;
      selectedTotalTimeCount = 0;
      selectedRatingCount = 0;
      selectedMealTypeCount = 0;
      selectedHealthCount = 0;
    });
  }

  Future<List<String>> loadFileAsList(String path) async {
  // Load the file content as a string
  String fileContent = await rootBundle.loadString(path);
  
  // Split the content by new lines into a list
  List<String> lines = fileContent.split('\n');
  
  return lines;
  }


  // The bottom filter sheet 
void showFilterBottomSheet (BuildContext context, {String? filterLabel}) async {
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Work on later!!!
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (filterLabel != null) {
          //       final targetKey = GlobalObjectKey(filterLabel);
          //       final targetContext = targetKey.currentContext;
          //       if (targetContext != null) {
          //         final box = targetContext.findRenderObject() as RenderBox;
          //         modalController.animateTo(
          //           modalController.position.pixels + box.localToGlobal(Offset.zero).dy,
          //           duration: const Duration(milliseconds: 300),
          //           curve: Curves.easeInOut,
          //         );
          //       }
          //     }
          // });
          return Stack(
            children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              // change appropriately 
              height: MediaQuery.of(context).size.height * 0.80,
              child: SingleChildScrollView(
                controller: modalController,
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 90),
                        child: Text(
                          "Recipes Filters", 
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          clearFilters();
                          fetchMoreRecipes();
                          Navigator.pop(context);
                        },
                        icon: Icon(MdiIcons.delete)
                      )
                      ]
                    ),
                    
                    // const SizedBox(height: 20),
                    // FilterOption(
                    //   key: const GlobalObjectKey('Ingredients'),
                    //   label: "Ingredients",
                    //   options: ingredients,
                    //   // options: const ["lemon juice","apple" , "applesauce","apricot", "asparagus", "bacon", "banana", "bagel", "basil", "bean", "beef", "beet", "berry", "blackberry", "blueberry", "bread", "broccoli", "butter"],
                    //   selectedOptions: selectedIngredients,
                    //   onSelected: (selectedOptions) {
                    //     setState(() {
                    //       selectedIngredientCount = selectedOptions.length;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Meal Types'),
                      label: "Meal Types",
                      options: const ["Pizza Recipes", "Seafood", "Bread", "Pies", "Drinks Recipes", "Desserts", "Breakfast and Brunch", "Salad", "Jams and Jellies Recipes", "Cookies"],
                      selectedOptions: selectedMealTypes,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedMealTypes = selectedOptions;
                          selectedMealTypeCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Ratings'),
                      label: "Ratings",
                      options: const ["5 stars", "4 stars", "3 stars", "2 stars", "1 star"],
                      selectedOptions: selectedRatings,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedRatings = selectedOptions;
                          selectedRatingCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Prep Times'),
                      label: "Prep Times",
                      options: const ["5 mins", "8 mins", "10 mins", "15 mins", "20 mins", "25 mins", "30 mins", "40 mins", "1 hrs"],
                      selectedOptions: selectedPrepTimes,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedPrepTimes = selectedOptions;
                          selectedPrepTimeCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Cooking Times'),
                      label: "Cooking Times",
                      options: const ["2 mins", "10 mins", "15 mins", "20 mins", "25 mins", "45 mins", "1 hrs"],
                      selectedOptions: selectedCookingTimes,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedCookingTimes = selectedOptions;
                          selectedCookingTimeCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Total Times'),
                      label: "Total Times",
                      options: const ["5 mins", "10 mins", "20 mins", "25 mins", "30 mins", "40 mins", "55 mins", "1 hrs"],
                      selectedOptions: selectedTotalTimes,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedTotalTimes = selectedOptions;
                          selectedTotalTimeCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Health'),
                      label: "Health",
                      options: const ["Sugar conscious", "Fat Free", "No Added Sugar", "Dairy Free", "Low Fat", "No Oil Added", "Alcohol Free"],
                      selectedOptions: selectedHeath,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedHeath = selectedOptions;
                          selectedHealthCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilterOption(
                      key: const GlobalObjectKey('Diets'),
                      label: "Diets",
                      options: const ["High Protein", "Low Carb", "Low fat", "Low Sodium", "Paleo", "Keto friendly", "Pescatarian"],
                      selectedOptions: selectedDiets,
                      onSelected: (selectedOptions) {
                        setState(() {
                          selectedDiets = selectedOptions;
                          selectedDietCount = selectedOptions.length;
                        });
                      },
                    ),
                    const SizedBox(height: 60,)
                  ]
                ),
              ),   
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    fetchMoreRecipes();
                    log(selectedDiets.toString());
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor
                  ),
              child: const Text("Apply filters")
            ),
           ),
         ),
            ]
          );
        }
      );
    }
  );
}

  void onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchMoreRecipes();
    }
  }

void fetchMoreRecipes({int pageIndex = 0}) {
  if (_recipeStorage != null) {
    List<String>? trimmedIngredients = selectedIngredients?.map((ingredient) => ingredient.trim()).toList();

    _recipeStorage!.fetchRecipes(
      limit: pageSize,
      pageIndex: pageIndex,
      searchQuery: searchQuery,
      diets: selectedDiets,
      ingredients: trimmedIngredients,
      mealTypes: selectedMealTypes,
      ratings: selectedRatings,
      prepTimes: selectedPrepTimes,
      cookingTimes: selectedCookingTimes,
      totalTimes: selectedTotalTimes,
      health: selectedHeath,
    ).then((recipes) {
      log("Fetched recipes count: ${recipes.length}");
      setState(() {
        if (recipes.isNotEmpty) {
          _recipeStorage!.cacheRecipes(recipes);
        }
        searchBloc.add(SearchWithFilters(
          searchText: searchQuery,
          diets: selectedDiets,
          ingredients: selectedIngredients,
          mealTypes: selectedMealTypes,
          ratings: selectedRatings,
          prepTimes: selectedPrepTimes,
          cookingTimes: selectedCookingTimes,
          totalTimes: selectedTotalTimes,
          health: selectedHeath,
        ));
      });
    });
  }
}


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _searchController = TextEditingController();
    _searchController.addListener(onSearchChanged);
    _recipeStorage = Provider.of<RecipeStorage>(context, listen: false);
    searchBloc = SearchBloc(_recipeStorage!);
    scrollController.addListener(onScroll);
    searchBloc.add(const SearchTextChanged("")); 
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _focusNode.unfocus(); // Hide keyboard when app is inactive or paused
      _keyboardVisible = false;
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && !_keyboardVisible) {
      _focusNode.unfocus();
    }
  }

 void onSearchChanged() {
  final query = _searchController.text;
  setState(() {
    searchQuery = query;
    currentPage = 0;
    lastDocument = null;
    _keyboardVisible = true;
    fetchMoreRecipes(); // Ensure we fetch recipes with the new search query
    if (query.isNotEmpty) {
      searchBloc.add(SearchTextChanged(query.toLowerCase()));
    }
  });
}


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _searchController.removeListener(onSearchChanged);
    scrollController.dispose();
    _searchController.dispose();
    searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchBloc,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppBar(
              backgroundColor: backgroundColor,
              scrolledUnderElevation: 0,
              title: SizedBox(
                height: 50,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 189, 189, 189),
                    ),
                    prefixIcon: Icon(MdiIcons.magnify),
                    suffixIcon: searchQuery.isNotEmpty ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _keyboardVisible = false;
                        fetchMoreRecipes();
                      },
                      icon: Icon(MdiIcons.close)
                    ) : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: true,
                  ),
                ),
              ),
              bottom: PreferredSize(
                  preferredSize: 
                  const Size.fromHeight(40), 
                  child: _filterTabs(),
            )),
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchError) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            } else if (state is SearchSuccess) {
              final recipes = state.recipes;
              if (recipes.isEmpty) {
                return const Center(
                  child: Text("No recipes found")
                );
              }
                return Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          CloudRecipe recipe = recipes[index];
                          return Card(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResponsiveWrapper.builder(
                                                  RecipeView(recipe: recipe),
                                                  breakpoints: const [
                                                    ResponsiveBreakpoint.resize(
                                                        480,
                                                        name: MOBILE),
                                                    ResponsiveBreakpoint.resize(
                                                        800,
                                                        name: TABLET),
                                                    ResponsiveBreakpoint
                                                        .autoScale(1000,
                                                            name: DESKTOP),
                                                    ResponsiveBreakpoint
                                                        .autoScale(2460,
                                                            name: '4K'),
                                                  ],
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        recipe.imageSrc ??
                                            recipe.imageUrl ??
                                            "",
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey,
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
                                          height: 350,
                                          color: Colors.black.withOpacity(0.3),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0),
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
                                      // Like button
                                      Positioned(
                                        top: 8,
                                        right: 3,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          padding: const EdgeInsets.all(
                                              0), // Adjusted padding
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              MdiIcons.heartOutline,
                                              color: const Color.fromARGB(
                                                  255, 153, 142, 160),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
            } else {
              return const Center(
                child: Text("No recipes found")
              );
            }
          },
        ),
      ),
    );
  }

  Column _filterTabs() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              IconButton(
                onPressed: () {
                  clearFilters();
                  fetchMoreRecipes();
                }, 
                icon: Icon(MdiIcons.delete)
              ),
              const SizedBox(width: 10),
              FilterButton(
                label: "Ingredient",
                count: selectedIngredientCount,
                onTap: () async {
          List<String> ingredients = await loadFileAsList('assets/ingredients/uniqueIngredient.txt');
        Navigator.push(
            context,
        MaterialPageRoute(
        builder: (context) => MoreIngredientsScreen(
          allIngredients: ingredients,
          selectedIngredients: selectedIngredients!,
          onSelectionChanged: (selectedOptions) {
            setState(() {
              selectedIngredients = selectedOptions.map((ingredient) => ingredient.trim()).toList();
              selectedIngredientCount = selectedIngredients!.length;
              log(selectedIngredients.toString());
              fetchMoreRecipes();
            });
          },
        ),
      ),
    );
  },
),

              const SizedBox(width: 10),
              FilterButton(
                label: "Meal Type",
                count: selectedMealTypeCount,
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Meal Types");
                },
              ),
              const SizedBox(width: 10),
              FilterButton(
                label: "Rating",
                count: selectedRatingCount,
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Ratings");
                },
              ),
              // const SizedBox(width: 10),
              // FilterButton(
              //   label: "Nutrition",
              //   count: selectedNutritionCount,
              //   onTap: () {
              //     log("Nutrition Tapped");
              //   },
              // ),
              const SizedBox(width: 10),
              FilterButton(
                label: "Prep Time",
                count: selectedPrepTimeCount,
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Prep Times");
                },
              ),
              const SizedBox(width: 10),
              FilterButton(
                label: "Cooking Time",
                count: selectedCookingTimeCount,
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Cooking Times");
                },
              ),
              const SizedBox(width: 10),
              FilterButton(
                label: "Total time",
                count: selectedTotalTimeCount,
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Total Times");
                },
              ),
              const SizedBox(width: 10),
              FilterButton(
                label: "Heath",
                count: selectedHealthCount,
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Health");
                },
              ),
              const SizedBox(height: 10,),
              FilterButton(
                label: "Diet", 
                count: selectedDietCount, 
                onTap: () {
                  showFilterBottomSheet(context, filterLabel: "Diets");
                }
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget filterRow(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: InputChip(
        label: Text(label),
        backgroundColor: miniTileColor,
        padding: const EdgeInsets.all(2),
        selected: selectedFilter.contains(label),
        selectedColor: const Color.fromARGB(255, 226, 226, 226),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              selectedFilter.add(label);
            } else {
              selectedFilter.remove(label);
            }
          });
        },
      ),
    );
  }
}


// For the filter options screen once a user presses on of the filter options
