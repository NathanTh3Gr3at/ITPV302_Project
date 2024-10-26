import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class GenericRecipeView extends StatefulWidget {
  final String cuisine;
  const GenericRecipeView({super.key, required this.cuisine});

  @override
  State<GenericRecipeView> createState() => _GenericRecipeViewState();
}

class _GenericRecipeViewState extends State<GenericRecipeView> {
  late TextEditingController _searchController;
  Set<String> selectedFilter = {};

  @override
  void initState() {
    _searchController = TextEditingController(text: widget.cuisine);
    super.initState();
  }

  @override
  void dispose() {
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
              // Handle search logic here
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40), 
          child: _filterTabs()
        ),
      ),
      body: const Center (
        child: Text("The Recipes will go here")
      )
    );
  }
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


 