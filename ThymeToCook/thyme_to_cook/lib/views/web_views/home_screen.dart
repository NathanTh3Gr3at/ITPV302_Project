import 'package:flutter/material.dart';
import 'package:thyme_to_cook/views/web_views/desktop_scaffold.dart';
import 'package:thyme_to_cook/views/web_views/mobile_scaffold.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Desktop layout
          return DesktopScaffold();
        } else {
          // Tablet and Mobile layout
          return MobileScaffold();
        }
      },
    );
  }
}

// Use to make layout better: 
// import 'package:flutter/material.dart';

// class RecipeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth > 800) {
//             return Center(
//               child: Container(
//                 width: 800,
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: RecipeContent(), // your recipe content widget here
//               ),
//             );
//           } else {
//             return RecipeContent(); // fallback for smaller screens
//           }
//         },
//       ),
//     );
//   }
// }

// class RecipeContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // your recipe content widgets here
//       ],
//     );
//   }
// }
