

class RecipeModel {
  String name;
  String iconPath;
  String nutrition;
  String duration;
  bool liked;

  RecipeModel({
    required this.name,
    required this.iconPath,
    required this.nutrition,
    required this.duration,
    this.liked = false,
  });



static List<RecipeModel> getRecipe() {
  List<RecipeModel> recipe = [];

    // 5 in placeholder
  
  recipe.add(     
    RecipeModel(
      name: 'Recipe Name',       // placeholder text
      iconPath: 'assets/images/placeholder_image.jpg', 
      nutrition: 'vegan', 
      duration: '30 min',
       liked: false, 
      
    )
  );

  recipe.add(     
    RecipeModel(
      name: 'Recipe Name',       // placeholder text
      iconPath: 'assets/images/placeholder_image.jpg', 
      nutrition: 'vegan', 
      duration: '30 min',
      liked: false, 
      
    )
  );

  recipe.add(     
      RecipeModel(
        name: 'Recipe Name',       // placeholder text
        iconPath: 'assets/images/placeholder_image.jpg', 
        nutrition: 'vegan', 
        duration: '30 min',
        liked: false, 
        
      )
    );
 return recipe;
  }
 
}
