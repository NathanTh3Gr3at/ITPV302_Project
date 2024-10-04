import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });



static List<CategoryModel> getCategories() {
  // change recomendation box color here
  const color = recTileColor;
  List<CategoryModel> categories = [];

    // 5 in placeholder
  
  categories.add(     
    CategoryModel(
      name: "....",       // placeholder text
      iconPath: 'assets/icon/placeholder_image.jpg', 
      boxColor: color,
    )
  );

  categories.add(     
    CategoryModel(
      name: "....",       
      iconPath: 'assets/placeholder_image.jpg', 
       boxColor: color
    )
  );

  categories.add(     
    CategoryModel(
      name: "....",       
      iconPath: 'assets/placeholder_image.jpg', 
      boxColor: color
    )
  );

  categories.add(     
    CategoryModel(
      name: "....",       
      iconPath: 'assets/placeholder_image.jpg', 
     boxColor: color
    )
  );

  categories.add(     
    CategoryModel(
      name: "....",       
      iconPath: 'assets/placeholder_image.jpg', 
    boxColor: color
    )
  );
    return categories;
  }


}
