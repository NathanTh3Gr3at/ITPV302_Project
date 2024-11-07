import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/auth/auth_user.dart';
import 'package:thyme_to_cook/services/auth/auth_user_storage.dart';
import 'package:thyme_to_cook/services/auth/bloc/save_recipe_function/save_cubit.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/sections/daily_delights_view.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class AdjustedHomeView extends StatefulWidget {
  const AdjustedHomeView({super.key});
  @override
  State<AdjustedHomeView> createState() => _AdjustedHomeViewState();
}

class _AdjustedHomeViewState extends State<AdjustedHomeView>
    with TickerProviderStateMixin {
  // late TabController _tabController;
  // late TabController _disTabController;
  bool isOffline = false;
  final ScrollController scrollController = ScrollController();
  final ScrollController exploreController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  RecipeStorage? _recipeStorage;
  List<String>? selectedMealTypes;
  int pageIndex = 0;
  late SearchBloc searchBloc;
  final List<CloudRecipe> _recipes = [];
  List<CloudRecipe> inifiteRecipes = [];
  late String firstLetter;

  void onScroll() {
    if (exploreController.position.pixels ==
        exploreController.position.maxScrollExtent) {
      pageIndex += 1;
      fetchMoreRecipes();
    }
  }

  List<String> userDiet = [];

  fetchBasedOnPreferences({int pageIndex = 0}) {
    if (_recipeStorage != null) {
      _recipeStorage!.fetchRecipes(
        limit: pageSize,
        pageIndex: pageIndex,
        totalTimes: ["30 mins"],
      ).then((recipes) {
        log("Fetched recipes count: ${recipes.length}");
        setState(() {
          _recipes.addAll(recipes);
          searchBloc.add(const SearchWithFilters(
            searchText: "",
            totalTimes: ["30 mins"],
          ));
        });
      });
    }
  }

  // Method to fetch recipes --> if the user changes the search this will be triggered and fetch new recipes
  void fetch30Recipes({int pageIndex = 0}) {
    if (_recipeStorage != null) {
      _recipeStorage!.fetchRecipes(
        limit: pageSize,
        pageIndex: pageIndex,
        totalTimes: ["30 mins"],
      ).then((recipes) {
        log("Fetched recipes count: ${recipes.length}");
        setState(() {
          _recipes.addAll(recipes);
          searchBloc.add(const SearchWithFilters(
            searchText: "",
            totalTimes: ["30 mins"],
          ));
        });
      });
    }
  }

  void fetchMoreRecipes({int pageIndex = 0}) {
    if (_recipeStorage != null) {
      _recipeStorage!
          .fetchRecipes(
        limit: 200,
        pageIndex: pageIndex,
      )
          .then((recipes) {
        log("Fetched recipes count: ${recipes.length}");
        setState(() {
          inifiteRecipes.addAll(recipes);
        });
      });
    }
  }

  final AuthUserStorage _authUserStorage = AuthUserStorage();
  String? username;

  Future<void> _fetchUsername() async {
    try {
      String fetchedUsername = await _authUserStorage.getUsername();
      setState(() {
        username = fetchedUsername;
      });
    } catch (e) {
      // Handle error
      setState(() {
        username = "Error fetching username";
      });
    }
  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authUser = Provider.of<AuthUser>(context); 
    firstLetter = authUser.username.isNotEmpty ? authUser.username[0].toUpperCase() : '';
  }

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _recipeStorage = Provider.of<RecipeStorage>(context, listen: false);
    searchBloc = SearchBloc(_recipeStorage!);
    exploreController.addListener(onScroll);
    fetch30Recipes();
    fetchMoreRecipes();
  }

  @override
  void dispose() {
    exploreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myDay = TimeOfDay.fromDateTime(DateTime.now());
    String greeting() {
      if (myDay.hour > 18) {
        return "Good Evening";
      } else if (myDay.hour > 12) {
        return "Good Afternoon";
      } else {
        return "Good Morning";
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(greeting(),
              style: const TextStyle(
                color: Color.fromARGB(255, 2, 2, 2),
                fontSize: 27,
                fontWeight: FontWeight.bold,
              )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromARGB(255, 162, 206, 100),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileView(),
                  ),
                );
              },
              icon: Center(child: Text( firstLetter, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, ), )),
            ),
          )
        ]),
        backgroundColor: backgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetch30Recipes();
          fetchMoreRecipes();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const MainNavigation(isLoggedIn: true),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: SingleChildScrollView(
          child: ResponsiveRowColumn(
              layout: ResponsiveWrapper.of(context).isSmallerThan('4K')
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                const ResponsiveRowColumnItem(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                                ResponsiveRowColumnItem(
                  child: Container(
                    height: 310,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 247, 245),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "Recommended",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(bottom: 25, left: 16),
                            child: inifiteRecipes.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListView.builder(
                                    controller: scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 15,
                                    itemBuilder: (context, index) {
                                      final displayRecipes =
                                          inifiteRecipes.take(15).toList();
                                      final recipe = displayRecipes[index];
                                      final imageUrl =
                                          recipe.identifier == "kaggle"
                                              ? recipe.imageSrc
                                              : recipe.imageUrl;
                                      return SizedBox(
                                        height: double.infinity,
                                        width: 210,
                                        child: Card(
                                          clipBehavior: Clip.hardEdge,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          borderOnForeground: true,
                                          elevation: 2,
                                          child: Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResponsiveWrapper
                                                              .builder(
                                                        RecipeView(
                                                            recipe: recipe),
                                                        breakpoints: const [
                                                          ResponsiveBreakpoint
                                                              .resize(480,
                                                                  name: MOBILE),
                                                          ResponsiveBreakpoint
                                                              .resize(800,
                                                                  name: TABLET),
                                                          ResponsiveBreakpoint
                                                              .autoScale(1000,
                                                                  name:
                                                                      DESKTOP),
                                                          ResponsiveBreakpoint
                                                              .autoScale(2460,
                                                                  name: '4K'),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      imageUrl ?? "",
                                                      fit: BoxFit.cover,
                                                      height: 265,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color: Colors.grey,
                                                          child: const Center(
                                                            child: Text(
                                                                ''),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 280,
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    12.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            recipe.recipeName,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const ResponsiveRowColumnItem(
                    child: SizedBox(
                  height: 20,
                )),
                ResponsiveRowColumnItem(
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 247, 245),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, top: 16, left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Daily Delights",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(bottom: 25, left: 16),
                            child: const DailyDelightsView(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const ResponsiveRowColumnItem(
                    child: SizedBox(
                  height: 20,
                )),
                ResponsiveRowColumnItem(
                  child: Container(
                    height: 340,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 247, 245),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, top: 16, left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "30 Minute Recipes",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(bottom: 25, left: 16),
                            child: _recipes.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListView.builder(
                                    controller: scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _recipes.length,
                                    itemBuilder: (context, index) {
                                      final recipe = _recipes[index];
                                      final imageUrl =
                                          recipe.identifier == "kaggle"
                                              ? recipe.imageSrc
                                              : recipe.imageUrl;
                                      return SizedBox(
                                        height: double.infinity,
                                        width: 210,
                                        child: Card(
                                          clipBehavior: Clip.hardEdge,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          borderOnForeground: true,
                                          elevation: 2,
                                          child: Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResponsiveWrapper
                                                              .builder(
                                                        RecipeView(
                                                            recipe: recipe),
                                                        breakpoints: const [
                                                          ResponsiveBreakpoint
                                                              .resize(480,
                                                                  name: MOBILE),
                                                          ResponsiveBreakpoint
                                                              .resize(800,
                                                                  name: TABLET),
                                                          ResponsiveBreakpoint
                                                              .autoScale(1000,
                                                                  name:
                                                                      DESKTOP),
                                                          ResponsiveBreakpoint
                                                              .autoScale(2460,
                                                                  name: '4K'),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      imageUrl ?? "",
                                                      fit: BoxFit.cover,
                                                      height: 265,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
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
                                                        height: 280,
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    12.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            recipe.recipeName,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                                          child: BlocBuilder<SaveRecipeCubit, List<CloudRecipe>>(
                                        builder: (context, likedRecipes) {
                                          final isLiked = likedRecipes.any((liked) => liked.recipeId == recipe.recipeId);
                                          return IconButton(
                                            onPressed: () {
                                              // setState(() {
                                                final saveRecipe = context
                                                    .read<SaveRecipeCubit>();

                                                if(isLiked) {
                                                  saveRecipe.unlike(recipe.recipeId);
                                                }
                                                else {
                                                  saveRecipe.likeRecipe(recipe);
                                                }
                                            },
                                            icon: Icon(
                                              isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
                                              color: isLiked ? Colors.red :Colors.grey 
                                            ),
                                          );
                                        }
                                        ),
                                      ),
                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const ResponsiveRowColumnItem(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                // Third Container
                ResponsiveRowColumnItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 247, 245),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18)),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, top: 16, left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Explore Recipes",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        controller: exploreController,
                        physics:
                            const NeverScrollableScrollPhysics(), // Ensures it uses the main scroll
                        shrinkWrap:
                            true, // Ensures it doesn't expand infinitely
                        itemCount: inifiteRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = inifiteRecipes[index];
                          String? imageUrl = recipe.identifier == "kaggle"
                              ? recipe.imageSrc
                              : recipe.imageUrl;
                          return Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
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
                                              ),
                                            ));
                                      },
                                      child: Image.network(
                                        imageUrl ?? "",
                                        fit: BoxFit.cover,
                                        height: 220,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 220,
                                            color: Colors.grey,
                                            child: const Center(
                                                child: Text('Image not found')),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 300,
                                      padding: const EdgeInsets.all(8),
                                      color: const Color.fromARGB(
                                          255, 246, 247, 245),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              Icon(MdiIcons.star,
                                                  color: Colors.amber,
                                                  size: 16),
                                              const SizedBox(width: 5),
                                              Text(
                                                  recipe.rating?.toString() ??
                                                      'N/A',
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                              const Spacer(),
                                              Icon(MdiIcons.fire,
                                                  color: Colors.red, size: 16),
                                              const SizedBox(width: 5),
                                              Text(
                                                  recipe.calories?.toString() ??
                                                      'N/A',
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(MdiIcons.clock,
                                                  color: Colors.grey, size: 16),
                                              const SizedBox(width: 5),
                                              Text(
                                                  recipe.totalTime
                                                          ?.toString() ??
                                                      'N/A',
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
