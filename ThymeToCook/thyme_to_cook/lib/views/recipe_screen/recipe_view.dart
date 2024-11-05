import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/grocery_list_function/grocery_list_event.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class RecipeView extends StatefulWidget {
  final CloudRecipe recipe;
  const RecipeView({super.key, required this.recipe});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isScrolledTo400 = false;
  late bool totalTimeAvailable = widget.recipe.totalTime != null ? true : false;
  late int recipeServings;
  String _selectedOption = "Convert Units";
  late int initialServings = widget.recipe.recipeServings ?? 1;

  List<RecipeIngredient> _adjustIngredients() {
    return widget.recipe.recipeIngredients.map((ingredient) {
      double adjustedQuantity =
          (ingredient.quantity ?? 0) * (recipeServings / initialServings);
      String unit = ingredient.unit ?? "";

      // Converting units based on selected metric option
      if (_selectedOption == "Metric") {
        if (unit == "cup") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "cup", "ml");
          unit = "ml";
        } else if (unit == "oz" || unit == "ounce" || unit == "ounces") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "oz", "g");
          unit = "g";
        } else if (unit == "lb" || unit == "pound" || unit == "pounds") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "lb", "kg");
          unit = "kg";
        } else if (unit == "qt" || unit == "quart" || unit == "qz") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "qt", "l");
          unit = "l";
        } else if (unit == "pt") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "pt", "l");
          unit = "l";
        }
      } else if (_selectedOption == "Imperial") {
        if (unit == "ml") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "ml", "cup");
          unit = "cup";
        } else if (unit == "g") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "g", "oz");
          unit = "oz";
        } else if (unit == "kg") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "kg", "lb");
          unit = "lb";
        } else if (unit == "l") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "l", "qt");
          unit = "qt";
        } else if (unit == "l") {
          adjustedQuantity = _convertUnits(adjustedQuantity, "l", "pt");
          unit = "pt";
        }
      }

      if (adjustedQuantity > 1 && unit == "cup") {
        unit = "cups";
      }
      if (adjustedQuantity > 1 && unit == "teaspoon") {
        unit = "teaspoons";
      }
      if (adjustedQuantity > 1 && unit == "tablespoon") {
        unit = "tablespoons";
      }
      if (adjustedQuantity == 1 && unit == "cups") {
        unit = "cup";
      }

      return RecipeIngredient(
        quantity: adjustedQuantity,
        unit: unit,
        ingredientName: ingredient.ingredientName,
      );
    }).toList();
  }

  double _convertUnits(double quantity, String unitBeforeConversion,
      String unitAfterConversion) {
    // Conversion logic
    if (unitBeforeConversion == "cup" && unitAfterConversion == "ml") {
      return quantity * 240.0;
    } else if (unitBeforeConversion == "ml" && unitAfterConversion == "cup") {
      return quantity / 240.0;
    } else if (unitBeforeConversion == "oz" && unitAfterConversion == "g") {
      return quantity * 28.35;
    } else if (unitBeforeConversion == "g" && unitAfterConversion == "oz") {
      return quantity / 28.35;
    } else if ((unitBeforeConversion == "lb" ||
            unitBeforeConversion == "pound" ||
            unitBeforeConversion == "pounds") &&
        unitAfterConversion == "kg") {
      return quantity * 0.453592;
    } else if ((unitBeforeConversion == "kg") &&
        (unitAfterConversion == "lb" ||
            unitAfterConversion == "pound" ||
            unitAfterConversion == "pounds")) {
      return quantity / 0.453592;
    } else if ((unitBeforeConversion == "qt" ||
            unitBeforeConversion == "quart" ||
            unitBeforeConversion == "qz") &&
        unitAfterConversion == "l") {
      return quantity * 0.946353;
    } else if ((unitBeforeConversion == "l") &&
        (unitAfterConversion == "qt" ||
            unitAfterConversion == "quart" ||
            unitAfterConversion == "qz")) {
      return quantity / 0.946353;
    } else if (unitBeforeConversion == "pt" && unitAfterConversion == "l") {
      // Converting pints to liters
      return quantity * 0.473176;
    } else if (unitBeforeConversion == "l" && unitAfterConversion == "pt") {
      // Converting liters to pints
      return quantity / 0.473176;
    }
    return quantity;
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    // Checking if the image end has been reached and now the tab bar will connect and the app bar will no longer be transparent
    _scrollController.addListener(() {
      if (_scrollController.offset >= 200 && !_isScrolledTo400) {
        setState(() {
          _isScrolledTo400 = true;
        });
      } else if (_scrollController.offset < 200 && _isScrolledTo400) {
        setState(() {
          _isScrolledTo400 = false;
        });
      }
    });
    recipeServings = initialServings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  MdiIcons.chevronLeft,
                  color: _isScrolledTo400 ? Colors.black : Colors.white,
                ),
                iconSize: 35,
              ),
              leadingWidth: 40,
              title: Text(
                widget.recipe.recipeName,
                style: TextStyle(
                  // Change the text color of the app bar depending on weather the image is above or not
                  color: _isScrolledTo400 ? Colors.black : Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              expandedHeight: 360,
              floating: false,
              pinned: true,
              actions: const [],
              scrolledUnderElevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: _imageArea(),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarTabBar(
                TabBar(
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicatorColor: const Color.fromARGB(122, 0, 0, 0),
                  labelColor: const Color.fromARGB(122, 0, 0, 0),
                  unselectedLabelColor:
                      const Color.fromARGB(121, 138, 133, 133),
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    const Tab(
                      child: Column(
                        children: [
                          Text("Overview"),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          const Text("Ingredients"),
                          Text(
                            "${widget.recipe.recipeIngredients.length.toString()} items",
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          const Text("Instructions"),
                          if (widget.recipe.totalTime?.isNotEmpty == true)
                            Text(
                              widget.recipe.totalTime!,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Tab(
                      child: Column(
                        children: [
                          Text("Nutritional Info"),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
            )
          ];
        },
        // body with the details of the recipe
        body: Container(
          height: 1000,
          color: backgroundColor,
          child: TabBarView(
            controller: _tabController,
            children: [
              overview(),
              ingredients(),
              instructions(),
              nutritionalInfo()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool addGrocery = await _showGroceryConfirmationDialog(context);
          if (addGrocery) {
            context.read<GroceryListBloc>().add(GroceryListLoadEvent(
                  recipeName: widget.recipe.recipeName,
                  ingredients:
                      widget.recipe.recipeIngredients.cast<RecipeIngredient>(),
                  // widget.recipe.recipeIngredients.cast<Ingredient>(),
                ));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("${widget.recipe.recipeName} added to grocery list"),
              ),
            );
          }
          // for debugging
          // print("Sending groceryListLoadEvent with recipe: ${widget.recipe.recipeName}");
        },
        child: const Icon(Icons.shopping_bag),
      ),
    );
  }

  Stack _imageArea() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                widget.recipe.imageSrc ?? widget.recipe.imageUrl ?? ""),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 400,
          color: Colors.black.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
      ),
    ]);
  }

  Column instructions() {
    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const ElevatedButton(
                  // Do logic !!!!
                  onPressed: null,
                  child: Text(
                    "Cook with me",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )),
            )),
        Expanded(
          child: ListView.builder(
            itemCount: widget.recipe.recipeInstructions.length,
            itemBuilder: (context, index) {
              RecipeInstructions instruction =
                  widget.recipe.recipeInstructions[index];
              return Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Step ${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          instruction.instruction ?? "",
                        )),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column ingredients() {
    List<RecipeIngredient> adjustedIngredients = _adjustIngredients();
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (recipeServings > 1) {
                        recipeServings -= 1;
                      }
                    });
                  },
                  icon: Icon(MdiIcons.minus),
                ),
                Text("${recipeServings.toString()} servings"),
                IconButton(
                  onPressed: () {
                    setState(() {
                      recipeServings += 1;
                    });
                  },
                  icon: Icon(MdiIcons.plus),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "Original",
                      child: Text("Original"),
                    ),
                    const PopupMenuItem(
                      value: "Metric",
                      child: Text("Metric"),
                    ),
                    const PopupMenuItem(
                      value: "Imperial",
                      child: Text("Imperial"),
                    ),
                  ],
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text(
                      _selectedOption,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            itemCount: adjustedIngredients.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.transparent),
            itemBuilder: (context, index) {
              RecipeIngredient ingredient = adjustedIngredients[index];
              String formattedQuantity = ingredient.getQuantityAsFraction();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  children: [
                    if (formattedQuantity.isNotEmpty &&
                        formattedQuantity != "0")
                      Text(
                        formattedQuantity,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    if (ingredient.unit != null && ingredient.unit!.isNotEmpty)
                      Text(
                        ' ${ingredient.unit!}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        ingredient.ingredientName ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column overview() {
    return const Column(children: [Text("This is the Overview")]);
  }

  Column nutritionalInfo() {
    return const Column(
        children: [Text("This is the nutritional information")]);
  }

  Future<bool> _showGroceryConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add to grocery list'),
              content: const Text('Add this recipe to your grocery list?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class _SliverAppBarTabBar extends SliverPersistentHeaderDelegate {
  _SliverAppBarTabBar(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarTabBar oldDelegate) {
    return false;
  }
}
