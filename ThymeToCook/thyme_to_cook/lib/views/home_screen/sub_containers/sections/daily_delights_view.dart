import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/views/home_screen/sub_containers/sections/generic_search_view.dart';

class DailyDelightsView extends StatefulWidget {

  const DailyDelightsView({super.key});

  @override
  State<DailyDelightsView> createState() => _DailyDelightsViewState();
}

class _DailyDelightsViewState extends State<DailyDelightsView> {
  final recipeCategories = [
    "Desserts", "Dinner", "Snacks", "Drinks", "Breakfast", "Lunch", "Healthy",  "Soups", "Salads" 
  ];
  final recipeCategoryImages = [
    "https://www.allrecipes.com/thmb/B4ncMNu-G9XgfqtyIKYiT6TcWd0=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/277000-easy-vanilla-cake-ddmfs-3X4-0103-09ae059661e5407599625222c5ac7d3b.jpg",
    "https://www.allrecipes.com/thmb/0qq5HbfjAFH5JF_QNu6WRKYclOw=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/8696926_Seared-Chuck-Eye-Steak_Dotdash-Meredith-Food-Studios_4x3-820877383c1b445fa7a7c6c1315f75d0.jpg",
    "https://www.allrecipes.com/thmb/YAvncdOdR2eEJ4cDuGRUcVe8dD8=/0x512/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/20482-baked-tortilla-chips-DDMFS-4x3-9c0db75a920c4bebbb6166984c8ecf00.jpg",
    "https://www.allrecipes.com/thmb/aSshHZ5gA8mbDzhqAFdDt0n9ELs=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/8724011_Pomegranate-Mocktail_TheDailyGourmet_4x3-3276997ff2b64bb5a909047d17d32001.jpg",
    "https://www.allrecipes.com/thmb/n9_uG5xsq4uZ8-FVUIjIZZ-BzxQ=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/AimeeBroussard-ChocolateChipPancakes-Vertical4x3-6db2844b3c8049a69692765b07559511.jpg",
    "https://www.allrecipes.com/thmb/5EZT3_DbTs6IWNXHQiZW5daKnsQ=/0x512/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/AR-147103-delicious-egg-salad-for-sandwiches-DDMFS-4x3-ab3abdebb3c44c4fa45f64377002c990.jpg",
    "https://www.allrecipes.com/thmb/24lsftF2T6l8_wiXSVSxsg03pTQ=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Roasted-Butternut-Squash-with-Onions-Spinach-and-Craisins-f4d6522a182c4297a157284af86117d0.jpg",
    "https://www.allrecipes.com/thmb/-h-vJFdQ-rpP183yOuMmHNXrzto=/0x512/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/8715274-sheet-pan-tomato-soup-ddmfs-beauty-043-daa972ab539b4fe19e38822de21194f6.jpg",
    "https://www.allrecipes.com/thmb/M9vZZBM1RLwFrisYyiXYyFlgv_0=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Green_Goddess_Dressing_4x3-STEP_060-9f2282f3c8a745508e5da1c2777a51c6.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipeCategoryImages.length, 
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 150,
                    width: 210,
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                                builder: (context) => ResponsiveWrapper.builder(
                                  GenericSearchView(cuisine: recipeCategories.elementAt(index)),
                                  breakpoints: const [
                                  ResponsiveBreakpoint.resize(480, name: MOBILE),
                                  ResponsiveBreakpoint.resize(800, name: TABLET),
                                  ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                  ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                                  ],
                            )
                            )
                          );
                        },
                          child: Stack(
                            children: [
                            Image.network(
                                  recipeCategoryImages.elementAt(index),
                                  // recipeImages[index],
                                  width: 210,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: const Center(
                                          child: Text('Image not found')),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 280,
                                    color: Colors.black.withOpacity(0.2), 
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 45),
                                        child: Text(
                                          recipeCategories.elementAt(index), 
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
                              ),
                            ]
                          ),
                        ),
                        ]
                      ),
                    ),
                  );
                },
              );
    
  }
}