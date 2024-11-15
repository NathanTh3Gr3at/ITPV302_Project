class IngredientItem {
  final String name;
  late bool isBought;
  final List<IngredientItem> ingredients;

  IngredientItem(
    {
    this.ingredients = const [], 
    required this.name, 
    required this.isBought
    });

}
class Recipe {
  final String name;
  bool isExpanded;
  final List<IngredientItem> ingredients;

  Recipe({
    required this.name,
    this.ingredients = const [],
    this.isExpanded = false,
  });
}

final recipeTiles = <Recipe>[
  Recipe(
    name: "Recipe 1", 
    isExpanded: false,
    ingredients: [
      IngredientItem(name: "garlic", isBought: false),
      IngredientItem(name: "cooking oil", isBought: false),
    ],
    ),  
  Recipe(
    name: "recipe 2", 
    isExpanded: false,
    ingredients: [
      IngredientItem(name: "name", isBought: false),
    ]
    )
];
