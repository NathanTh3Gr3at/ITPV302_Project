class DbRecipeIngredient {
  final String? ingredientName;
  final double quantity;
  final String? unit;
  final bool isChecked;
  DbRecipeIngredient({
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    this.isChecked = false,
  });
  //Converts to SQLite Map
  Map<String, dynamic> toMap(String recipeId) {
    return {
      'ingredientName': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'isChecked': isChecked ? 1 : 0,
      'recipeId': recipeId,
    };
  }

  //Converts from SQLite map
  static DbRecipeIngredient fromMap(Map<String, dynamic> map) {
    return DbRecipeIngredient(
      ingredientName: map['ingredientName'],
      quantity: map['quantity'],
      unit: map['unit'],
      isChecked: map['isChecked'] == 1,
    );
  }
}
