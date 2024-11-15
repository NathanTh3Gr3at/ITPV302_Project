import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/create_recipe_function/created_recipe_qubit.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class CreateRecipeView extends StatefulWidget {
  const CreateRecipeView({super.key});

  @override
  State<CreateRecipeView> createState() => _CreateRecipeViewState();
}

class _CreateRecipeViewState extends State<CreateRecipeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _imageSrcController = TextEditingController();
  final _tagsController = TextEditingController();
  final _servingsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _cuisinePathController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _ratingController = TextEditingController();
  final _totalTimeController = TextEditingController();
  final _searchKeywordsController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _directionControllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _cookingTimeController.dispose();
    _imageSrcController.dispose();
    _tagsController.dispose();
    _servingsController.dispose();
    _caloriesController.dispose();
    _cuisinePathController.dispose();
    _imageUrlController.dispose();
    _prepTimeController.dispose();
    _ratingController.dispose();
    _totalTimeController.dispose();
    _searchKeywordsController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _directionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveRecipe() {
  if (_formKey.currentState?.validate() ?? false) {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final cookingTime = _cookingTimeController.text;
    final imageSrc = _imageSrcController.text;
    final tags = _tagsController.text.isNotEmpty
        ? Map<String, dynamic>.fromEntries(
            _tagsController.text.split(',').map((tag) => MapEntry(tag.trim(), true)),
          )
        : <String, dynamic>{};
    final servings = int.tryParse(_servingsController.text) ?? 1;
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final cuisinePath = _cuisinePathController.text.split(',').map((e) => e.trim()).toList();
    final imageUrl = _imageUrlController.text;
    final prepTime = _prepTimeController.text;
    final rating = _ratingController.text;
    final totalTime = _totalTimeController.text;
    final searchKeywords = _searchKeywordsController.text.split(',').map((e) => e.trim()).toList();
    final ingredients = _ingredientControllers.map((controller) => controller.text).toList();
    final directions = _directionControllers.map((controller) => controller.text).toList();

    final newRecipe = CloudRecipe(
      recipeId: DateTime.now().millisecondsSinceEpoch.toString(),
      recipeName: title,
      recipeDescription: description,
      recipeIngredients: ingredients.map((ingredient) => RecipeIngredient(
        ingredientName: ingredient,
        quantity: 1,
        unit: '',
      )).toList(),
      recipeInstructions: directions.map((direction) => RecipeInstructions(
        instruction: direction,
        time: 0,
        unit: '',
      )).toList(),
      cookingTime: cookingTime,
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
      calories: calories,
      tags: tags,
      recipeServings: servings,
      nutritionalInfo: [],
      cuisinePath: cuisinePath,
      imageSrc: imageSrc,
      imageUrl: imageUrl,
      identifier: 'user',
      prepTime: prepTime,
      rating: rating,
      totalTime: totalTime,
      recipeSearchKeywords: searchKeywords,
    );

    context.read<CreateRecipeQubit>().addRecipe(newRecipe);
    Navigator.of(context).pop();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Own Recipe'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Ingredients'),
            Tab(text: 'Directions'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildIngredientsTab(),
            _buildDirectionsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveRecipe,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _cookingTimeController,
            decoration: const InputDecoration(
              labelText: 'Cooking Time',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Cooking time is required' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _imageSrcController,
            decoration: const InputDecoration(
              labelText: 'Image Source',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _servingsController,
            decoration: const InputDecoration(
              labelText: 'Servings',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _caloriesController,
            decoration: const InputDecoration(
              labelText: 'Calories',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _cuisinePathController,
            decoration: const InputDecoration(
              labelText: 'Cuisine Path (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _prepTimeController,
            decoration: const InputDecoration(
              labelText: 'Prep Time',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ratingController,
            decoration: const InputDecoration(
              labelText: 'Rating',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _totalTimeController,
            decoration: const InputDecoration(
              labelText: 'Total Time',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _searchKeywordsController,
            decoration: const InputDecoration(
              labelText: 'Search Keywords (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildIngredientsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _ingredientControllers.length + 1,
              itemBuilder: (context, index) {
                if (index == _ingredientControllers.length) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _ingredientControllers.add(TextEditingController());
                      });
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _ingredientControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Ingredient ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Ingredient ${index + 1} is required' : null,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _directionControllers.length + 1,
              itemBuilder: (context, index) {
                if (index == _directionControllers.length) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _directionControllers.add(TextEditingController());
                      });
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _directionControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Step ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      validator: (value) => value?.isEmpty ?? true ? 'Step ${index + 1} is required' : null,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
