import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/recipe_storage.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class GenericSearchView extends StatefulWidget {
  final String cuisine;
  const GenericSearchView({super.key, required this.cuisine});

  @override
  State<GenericSearchView> createState() => _GenericSearchViewState();
}

class _GenericSearchViewState extends State<GenericSearchView> {
  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  late TextEditingController _searchController;
  Set<String> selectedFilter = {};
  RecipeStorage? _recipeStorage;
  String searchQuery = '';
  DocumentSnapshot? lastDocument;

  void onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchMoreRecipes();
    }
  }

  void fetchMoreRecipes() {
    if (_recipeStorage != null) {
      _recipeStorage!.fetchRecipes(
        limit: pageSize,
        startAfterDocument: lastDocument,
        searchQuery: searchQuery
      ).then((recipes) {
        if (recipes.isNotEmpty) {
          lastDocument = recipes.last.docSnapshot; 
          _recipeStorage!.cacheRecipes(recipes);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recipeStorage = Provider.of<RecipeStorage>(context, listen: false);
    fetchMoreRecipes(); // Initial fetch
    scrollController.addListener(onScroll);
    _searchController = TextEditingController(text: widget.cuisine);
  }

  @override
  void dispose() {
    scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(MdiIcons.chevronLeft),
          iconSize: 35,
        ),
        leadingWidth: 40,
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 189, 189, 189),
              ),
              prefixIcon: Icon(MdiIcons.magnify),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (text) {
              setState(() {
                searchQuery = text;
                currentPage = 0;
                lastDocument = null;
                fetchMoreRecipes(); // Fetch new results based on search query
              });
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _filterTabs()
        ),
      ),
      body: StreamBuilder<List<CloudRecipe>>(
        stream: _recipeStorage?.getCachedRecipesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          } else {
            List<CloudRecipe> recipes = snapshot.data!;
            return GridView.builder(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
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
                      InkWell(
                        onTap: () {
                          log("Tapped");
                        },
                        child: Stack(
                          children: [
                            Image.network(
                              recipe.imageSrc ?? recipe.imageUrl ?? "",
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
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
                                height: 40, // Adjusted height to fit the text
                                color: Colors.black.withOpacity(0.6),
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    recipe.recipeName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                            // Like button 
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                padding: const EdgeInsets.all(0), // Adjusted padding
                                child: IconButton(
                                  onPressed: () {
                                    
                                  },
                                  icon: Icon(
                                    MdiIcons.heartOutline,
                                    color: const Color.fromARGB(255, 153, 142, 160),
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
            );
          }
        }
      ),
    );
  }

  Column _filterTabs() {
    return Column(
      children: [
        SingleChildScrollView(
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
