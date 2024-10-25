import 'package:flutter/material.dart';
import 'package:thyme_to_cook/navigation/bottom_nav_bar.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipe.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class RecipeView extends StatefulWidget {
  final CloudRecipe recipe;
  const RecipeView({super.key, required this.recipe});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}
//need to add in code for the view of instructions
class _RecipeViewState extends State<RecipeView> {
  final List<_RecipeInstruction> _instructionsList = []; //list of instructions

  @override
  void initState() {
    super.initState();
    _initializeInstructions(); // add instruction to list
  }

  void _initializeInstructions() {
    //replace with other code for now just to test
    _addInstruction('Instruction 1');
    _addInstruction('instruction 2');
  }

  void _addInstruction(String instruction) {
    setState(() {
      _instructionsList.add(_RecipeInstruction(instruction: instruction));
    });
  }

  void _toggleInstructionStatus(int index) {
    setState(() {
      _instructionsList[index].isDone = !_instructionsList[index].isDone;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
           widget.recipe.recipeName, 
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: _recipePage(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Column _recipePage() {
    return Column(
      children: [
        _imageArea(),
        const SizedBox(
        height: 10,
      ),
        _instructions(),
        
      ],
    );
  }

  Container _imageArea() {
  return Container(
    width: 320,
    height: 225,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/placeholder_image.jpg'),
        fit: BoxFit.cover, 
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}


  Column _instructions() {
    return Column(
      children: [
        Column(
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // tab sections
                  const TabBar(
                    tabs: [
                      Tab(
                        child: Text("Ingredients"),
                      ),
                      Tab(
                        child: Text("Instructions"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    child: TabBarView(
                      // text under each tab
                      children: [
                        Card(
                          color: backgroundColor,
                          // color: Color.fromARGB(255, 252, 253, 242),
                          // elevation: 5,
                          child: Center(
                            
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    widget.recipe.recipeIngredients[index],
                                  ),
                                );
                              },
                              itemCount: widget.recipe.recipeIngredients.length,
                            ),
                          ),
                        ),
                        Card(
                          color: backgroundColor,
                          child: Center(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    widget.recipe.recipeInstructions[index],
                                  ),
                                );
                              }, itemCount: widget.recipe.recipeInstructions.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
class _RecipeInstruction{
  final String instruction;
  bool isDone;
  _RecipeInstruction({required this.instruction, this.isDone = false});
}
