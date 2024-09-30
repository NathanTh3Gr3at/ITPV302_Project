import 'package:flutter/material.dart';

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
  const color = Color.fromARGB(255, 176, 255, 197);
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
