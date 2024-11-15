import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class MoreIngredientsScreen extends StatefulWidget {
  final List<String> allIngredients;
  final List<String> selectedIngredients;
  final Function(List<String>) onSelectionChanged;

  MoreIngredientsScreen({
    required this.allIngredients,
    required this.selectedIngredients,
    required this.onSelectionChanged,
  });

  @override
  _MoreIngredientsScreenState createState() => _MoreIngredientsScreenState();
}

class _MoreIngredientsScreenState extends State<MoreIngredientsScreen> {
  late List<String> filteredIngredients;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    filteredIngredients = widget.allIngredients;
    searchController = TextEditingController();
  }

  void filterIngredients(String query) {
    setState(() {
      filteredIngredients = widget.allIngredients
          .where((ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

   void clearSelectedIngredients() {
    setState(() {
      widget.selectedIngredients.clear();
    });
    widget.onSelectionChanged(widget.selectedIngredients);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Expanded(
              child: 
              Text('Search Ingredients')
          ),
            IconButton(
              icon: Icon(MdiIcons.delete),
              onPressed: clearSelectedIngredients,
            ),
          ],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              
              decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 189, 189, 189),
                      ),
                      labelText: 'Search Ingredients',
                      prefixIcon: Icon(MdiIcons.magnify),
                      suffixIcon: searchController.text.isNotEmpty ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(MdiIcons.close)
                      ) : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      filled: true,
                    ),
              onChanged: filterIngredients,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = filteredIngredients[index];
                final isSelected = widget.selectedIngredients.contains(ingredient);

                return ListTile(
                  title: Text(ingredient),
                  trailing: isSelected ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        widget.selectedIngredients.remove(ingredient);
                      } else {
                        widget.selectedIngredients.add(ingredient);
                      }
                    });
                    widget.onSelectionChanged(widget.selectedIngredients);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
