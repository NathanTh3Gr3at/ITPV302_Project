import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/enums/menu_action.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/grocery_list_screen/grocery_list_view.dart';
import 'package:thyme_to_cook/views/meal_planner_screen/meal_panner_view.dart';
import 'package:thyme_to_cook/views/profile_screen/profile_view.dart';
import 'package:thyme_to_cook/views/save_screen/save_view.dart';
import 'package:thyme_to_cook/views/search_screen/adjusted_search_view.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';
import 'package:thyme_to_cook/views/web_views/laptop.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold>  with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: const Color.fromARGB(255, 162, 206, 100),
        shape: const CircleBorder(),
        elevation: 20,
        child: Icon(
          MdiIcons.plus,
          color: const Color.fromARGB(255, 255, 255, 255),
          size: 30,
          ),
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            const Text("Thyme to Cook"),
            const SizedBox(width: 20),
            Expanded(
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Home"),
                  Tab(text: "Saved"),
                  Tab(text: "Search"),
                  Tab(text: "Planner"),
                  Tab(text: "Lists"),
                ],
                indicatorColor: const Color.fromARGB(255, 218, 218, 218),
                dividerColor: Colors.transparent,
              ),
            ),
          ],
        ),

      actions: [
          // pop menu
          PopupMenuButton<MenuAction>(
            icon: Container(
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 255, 255, 255),
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(MdiIcons.account, size: 30,)
            ),
            onSelected: (value) async {
              switch (value) {
                //handles logging out
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                // added menu action to go to profile view
                case MenuAction.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileView(),
                    ),
                  );
                //added a settings page
                case MenuAction.settings:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile,
                  child: Text("User Profile"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text("Settings"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                )
                // User profile text
              ];
            },
          )
        ],),
      body: TabBarView(
        controller: _tabController,
        children:[
          const Center(child: LaptopHomePageView()),
          Center(child: ResponsiveWrapper.builder(
                              const SaveView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
          Center(child: ResponsiveWrapper.builder(
                              const AdjustedSearchView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
          Center(child: ResponsiveWrapper.builder(
                              const MealPlannerView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
          Center(child: ResponsiveWrapper.builder(
                              const GroceryListView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),),
        ],
      ));
  }
}

// RefreshIndicator(       
//         onRefresh: () async {
//         },
//         child: SingleChildScrollView(
//           child: ResponsiveRowColumn(
//             layout: ResponsiveWrapper.of(context).isSmallerThan('4K')
//                 ? ResponsiveRowColumnType.COLUMN
//                 : ResponsiveRowColumnType.ROW,
//             children: [
//               const ResponsiveRowColumnItem(
//                 child: SizedBox(
//                   height: 20,
//                 )
//               ),
//               ResponsiveRowColumnItem(
//                 child: Container(
//                   height: 220,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(18)),
//                   ),
//                   child: Column(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only(bottom: 10, top: 16, left: 8),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 15),
//                             child: Text(
//                               "Daily Delights",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color:  Color.fromARGB(255, 0, 0, 0)
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.only(bottom: 25, left: 16),
//                           child: const DailyDelightsView(),
//                         ),
//                       ),  
//                     ],
//                   ),
//                 ),
//               ),
//               const ResponsiveRowColumnItem(
//                 child: SizedBox(
//                   height: 20,
//                 )
//               ),
              // ResponsiveRowColumnItem(
              //   child: Container(
              //     height: 340,
              //     decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(18)),
              //     ),
              //     child: Column(
              //       children: [
              //         const Padding(
              //           padding: EdgeInsets.only(bottom: 10, top: 16, left: 8),
              //           child: Align(
              //             alignment: Alignment.topLeft,
              //             child: Padding(
              //               padding: EdgeInsets.only(left: 15),
              //               child: Text(
              //                 "30 Minute Recipes",
              //                 style: TextStyle(
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.bold,
              //                   color:  Color.fromARGB(255, 0, 0, 0)
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         // Padding(
              //         //   padding: const EdgeInsets.only(left: 6, bottom: 20),
              //         //   child: TabBar(
              //         //               controller: _disTabController,
              //         //               indicatorColor:  const Color.fromARGB(122, 0, 0, 0),
              //         //               labelColor: const Color.fromARGB(122, 0, 0, 0),
              //         //               unselectedLabelColor: const Color.fromARGB(121, 138, 133, 133),
              //         //               isScrollable: true,
              //         //               tabAlignment: TabAlignment.start,
              //         //               dividerColor: Colors.transparent,
                                    
              //         //               tabs: const [
              //         //                   Tab(text: "Low-Carb"), 
              //         //           ],
              //         //         ),
              //         // ),  
              //         Expanded(
              //           child: Container(
              //             padding: const EdgeInsets.only(bottom: 25, left: 16),
              //             child: StreamBuilder(
              //                   stream: recipeStorage.getCachedRecipesStream(),
              //                   builder: (context, snapshot) {
              //                     switch (snapshot.connectionState) {
              //                       case ConnectionState.waiting:
              //                         return const Center(child: CircularProgressIndicator());
              //                       case ConnectionState.active:
              //                         if (_recipes.isEmpty) {
              //                           return const Center(child: Text("No Recipes available"));
              //                         }
              //                         // Limiting the number of recipes shown to the user
              //                         final displayRecipes = _recipes.take(limit).toList();
              //                         return ListView.builder(
              //                           controller: scrollController,
              //                           scrollDirection: Axis.horizontal,
              //                           itemCount: displayRecipes.length,
              //                           itemBuilder: (context, index) {
              //                             final recipe = displayRecipes[index];
              //                             String? imageUrl;
              //                             if (recipe.identifier == "kaggle") {
              //                               imageUrl = recipe.imageSrc;
              //                             } else {
              //                               imageUrl = recipe.imageUrl;
              //                             }
              //                             return SizedBox(
              //                               height: double.infinity,
              //                               width: 210,
              //                               child: Card(
              //                                 clipBehavior: Clip.hardEdge,
              //                                 shape: RoundedRectangleBorder(
              //                                   borderRadius: BorderRadius.circular(10),
              //                                 ),
              //                                 borderOnForeground: true,
              //                                 elevation: 2,
              //                                 child: Stack(
              //                                   children: [
              //                                     GestureDetector(
              //                                       onTap: () {
              //                                         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => ResponsiveWrapper.builder(
              //                 RecipeView(recipe: recipe),
              //                 breakpoints: const [
              //                   ResponsiveBreakpoint.resize(480, name: MOBILE),
              //                   ResponsiveBreakpoint.resize(800, name: TABLET),
              //                   ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
              //                   ResponsiveBreakpoint.autoScale(2460, name: '4K'),
              //                 ],
              //               )
              //             )
              //                                         );
              //                                       },
              //                                       child: Stack(
              //                                         children: [
              //             Image.network(
              //               imageUrl ?? "",
              //               fit: BoxFit.cover,
              //               height: 265,
              //               errorBuilder: (context, error, stackTrace) {
              //                 return Container(
              //                   color: Colors.grey,
              //                   child: const Center(child: Text('Image not found')),
              //                 );
              //               },
              //             ),
              //             Positioned(
              //               bottom: 0,
              //               left: 0,
              //               right: 0,
              //               child: Container(
              //                 height: 280,
              //                 color: Colors.black.withOpacity(0.1),
              //                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              //                 child: Align(
              //                   alignment: Alignment.bottomCenter,
              //                   child: Text(
              //                     recipe.recipeName,
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                     overflow: TextOverflow.clip,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Positioned(
              //               top: 10,
              //               right: 10,
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(100),
              //                   color: const Color.fromARGB(255, 255, 255, 255),
              //                 ),
              //                 padding: const EdgeInsets.symmetric(vertical: 0.1, horizontal: 0.1),
              //                 child: IconButton(
              //                   onPressed: () {
              //                     log(isLiked.toString());
              //                   },
              //                   icon: Icon(
              //                     MdiIcons.heartOutline,
              //                     color: const Color.fromARGB(255, 153, 142, 160),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             );
              //                           },
              //                         );
              //                       default:
              //                         return const Center(child: CircularProgressIndicator());
              //                     }
              //                   },
              //                 )
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
//               const ResponsiveRowColumnItem(
//                 child: SizedBox(
//                   height: 20,
//                 )
//               ),
//               // Third Container
//               ResponsiveRowColumnItem(
//                 child: Container(
//                   height: 310,
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 255, 255, 255),
//                     borderRadius: BorderRadius.all(Radius.circular(18)),
//                   ),
//                   child: Column(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only( top: 16),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 20),
//                             child: Text(
//                               "Recently Viewed",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromARGB(255, 0, 0, 0)
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.all(16.0),
//                           child: const RecommendedView(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const ResponsiveRowColumnItem(
//                 child: SizedBox(
//                   height: 20,
//                 )
//               ),
//               ResponsiveRowColumnItem(
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Padding(
//         padding: EdgeInsets.only(bottom: 10, top: 16, left: 8),
//         child: Align(
//           alignment: Alignment.topLeft,
//           child: Padding(
//             padding: EdgeInsets.only(left: 15),
//             child: Text(
//               "Explore Recipes",
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 0, 0, 0),
//               ),
//             ),
//           ),
//         ),
//       ),
//       ListView.builder(
//         controller: exploreController,
//         physics: const NeverScrollableScrollPhysics(), // Ensures it uses the main scroll
//         shrinkWrap: true, // Ensures it doesn't expand infinitely
//         itemCount: _recipes.length,
//         itemBuilder: (context, index) {
//           final recipe = _recipes[index];
//           String? imageUrl = recipe.identifier == "kaggle" ? recipe.imageSrc : recipe.imageUrl;
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ResponsiveWrapper.builder(
//                             RecipeView(recipe: recipe),
//                             breakpoints: const [
//                               ResponsiveBreakpoint.resize(480, name: MOBILE),
//                               ResponsiveBreakpoint.resize(800, name: TABLET),
//                               ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
//                               ResponsiveBreakpoint.autoScale(2460, name: '4K'),
//                             ],
//                           ),
//                         )
//                       );
//                     },
//                     child: Image.network(
//                       imageUrl ?? "",
//                       fit: BoxFit.cover,
//                       height: 220,
//                       width: double.infinity,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           height: 220,
//                           color: Colors.grey,
//                           child: const Center(child: Text('Image not found')),
//                         );
//                       },
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           recipe.recipeName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Icon(MdiIcons.star, color: Colors.amber, size: 16),
//                             const SizedBox(width: 5),
//                             Text(recipe.rating?.toString() ?? 'N/A', style: const TextStyle(fontSize: 14)),
//                             const Spacer(),
//                             Icon(MdiIcons.fire, color: Colors.red, size: 16),
//                             const SizedBox(width: 5),
//                             Text(recipe.calories?.toString() ?? 'N/A', style: const TextStyle(fontSize: 14)),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Icon(MdiIcons.clock, color: Colors.grey, size: 16),
//                             const SizedBox(width: 5),
//                             Text(recipe.totalTime?.toString() ?? 'N/A', style: const TextStyle(fontSize: 14)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     ],
//   ),
// ),
