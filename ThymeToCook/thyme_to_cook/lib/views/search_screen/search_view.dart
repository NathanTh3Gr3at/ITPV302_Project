import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
// import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_bloc.dart';
// import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_event.dart';
// import 'package:thyme_to_cook/services/auth/bloc/search_function/search_function_state.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/recipe_screen/recipe_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // tracks what user typed
  final TextEditingController searchController = TextEditingController();
  // late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    // searchBloc = BlocProvider.of<SearchBloc>(context);
    // searchController.addListener(onSearchChanged); // listens for each keystroke
    // _getRecipes();
  }

  // void onSearchChanged() {
  //   final query = searchController.text;
  //   if (searchController.text.isNotEmpty) {
  //     searchBloc.add(SelectSearchEvent(query));
  //   }
  // }

  // List<RecipeModel> recipes = [];
  Set<String> selectedFilter = {};

  // void _getRecipes() {
  //   recipes = RecipeModel.getRecipe();
  // }

  @override
  void dispose() {
    // searchController.removeListener(onSearchChanged);
    // searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _getInitial();
    return GestureDetector(
      onTap:()=>FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        body: Column(
          children: [
            _searchRecipes(),
            // Expanded(
            //   child: BlocBuilder<SearchBloc, SearchState>(
            //     builder: (context, state) {
            //       // if(state is SearchInitial)
            //       // {
            //       //   return _searchField();
            //       // }
            //       if (state is SearchLoaded) {
            //         // no recipes
            //         if (state.recipes.isEmpty) {
            //           return const Center(
            //             child: Text("No recipes found"),
            //           );
            //         }
      
            //         return ListView.separated(
            //           shrinkWrap: true, // wraps list content
      
            //           // amount of recipes being displayed
            //           // itemCount: recipes.length,
            //           itemCount: state.recipes.length,
      
            //           itemBuilder: (context, index) {
            //             final recipe = state.recipes[index];
            //             if (recipe == null) {
            //               return const SizedBox();
            //             }
            //             // return _searchRecipes(recipe: recipe);
      
            //             // Display UI
            //             return InkWell(
            //               onTap: () {
            //                 searchBloc.add(RecipeDetailEvent(recipe: recipe));
                            
            //                 // selecting to go to recipe screens
            //                 Navigator.of(context).push(
            //                   MaterialPageRoute(
            //                     builder: (context) => RecipeView(recipe: recipe),
            //                   ),
            //                 );
            //                 setState(() {
                              
            //                 });
            //               },
            //               child: Container(
            //                 height: 115,
            //                 decoration: BoxDecoration(
            //                   // color: recipe.liked
            //                   //     ? const Color.fromARGB(255, 240, 240, 240)
            //                   //     : Colors.transparent,
            //                   border: Border.all(
            //                     color: const Color.fromARGB(255, 232, 232, 232),
            //                   ),
            //                   borderRadius: BorderRadius.circular(15),
            //                   // boxShadow: recipes[index].liked
            //                   //     ? [
            //                   //         BoxShadow(
            //                   //           color: const Color.fromARGB(235, 217, 217, 217)
            //                   //               .withOpacity(0.5),
            //                   //           offset: const Offset(0, 9),
            //                   //           blurRadius: 20,
            //                   //           spreadRadius: 0,
            //                   //         )
            //                   //       ]
            //                   //     : [],
            //                 ),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                   children: [
            //                     // recipe image
            //                     // Image.asset(
            //                     //   Image.asset(
            //                     //     recipe.iconPath,
            //                     //     ),
            //                     //   width: 100,
            //                     //   height: 100,
            //                     // ),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           // getting recipe name
            //                           recipe.recipeName,
            //                           style: const TextStyle(
            //                               fontWeight: FontWeight.w500,
            //                               color: Colors.black,
            //                               fontSize: 20),
            //                           softWrap: true,
            //                           maxLines: 3,
            //                         ),
            //                         Text(
            //                           // getting recipe calories
            //                           'Calories: ${recipe.calories}',
            //                           style: const TextStyle(
            //                               color: Colors.black,
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w300),
            //                           softWrap: true,
            //                           maxLines: 1,
            //                         ),
            //                       ],
            //                     ),
            //                     //  Heart Icon
            //                     IconButton(
            //                       onPressed: () {
            //                         setState(
            //                           () {
            //                             // recipes[index].liked = recipe.copyWith(liked: !recipe.liked);
            //                           },
            //                         );
            //                       },
            //                       icon: const Icon(
            //                         Icons.favorite_border_rounded,
            //                         // recipes[index].liked
            //                         //     ? Icons.favorite
            //                         //     : Icons.favorite_border_rounded,
            //                         // color:
            //                         //     recipe[index].liked ? Colors.red : Colors.grey,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //           separatorBuilder: (context, index) => const SizedBox(
            //             height: 20,
            //           ),
            //           padding: const EdgeInsets.only(left: 10, right: 10),
            //         );
            //       }
      
            //       // loading
            //       else if (state is SearchLoading) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
      
            //       // error message
            //       else if (state is SearchError) {
            //         return Center(
            //           child: Text(state.errorMessage),
            //         );
            //       }
      
            //       return const Center(
            //         child: Text("Search for recipes"),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      title: const Text(
        "Search",
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Column _searchRecipes() {
    return Column(children: [
      const SizedBox(
        height: 2,
      ),
      _searchField(),
      const SizedBox(
        height: 5,
      ),
      _filterTabs(),
      const SizedBox(
        height: 5,
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 20),
                child: Text(
                  "Recipes you might like",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // const SizedBox(height: 10,
              // ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      )
    ]);
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 246, 235, 235).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0)
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: searchbarBackgroundColor,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.search),
          ),
          hintText: "Search for recipes",
          hintStyle: const TextStyle(
            color: Color.fromARGB(122, 0, 0, 0),
            fontSize: 12,
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.filter_alt_rounded),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

// filter section
  Column _filterTabs() {
    return Column(
      children: [
        SingleChildScrollView(
          // wraps filter row for scrolling
          scrollDirection: Axis.horizontal,
          child: Row(children: <Widget>[
            filterRow('Diet'),
            filterRow('Ingredients'),
            filterRow('Nutrition'),
            filterRow('Duration'),
          ]),
        ),
      ],
    );
  }

  Widget filterRow(String label) {
    // bool bIsSelected;
    // bIsSelected = false;
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
