import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thyme_to_cook/models/user_model.dart';
import 'package:thyme_to_cook/services/auth/bloc/create_recipe_function/created_recipe_qubit.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/settings_screen/settings_view.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';

class ProfileView extends StatefulWidget {
  static const routeName = '/profile';
  final UserModel? user;
  const ProfileView({super.key, this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  String? _profileImage;
  late String firstLetter;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user?.username ?? 'User';
    firstLetter = widget.user?.username != null && widget.user!.username!.isNotEmpty
        ? widget.user!.username![0].toUpperCase()
        : 'U'; // Default to 'U' if no username is provided
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Profile"),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ),
                );
              },
              icon: Icon(MdiIcons.cog, size: 30),
            ),
          ],
        ),

        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(MdiIcons.chevronLeft),
          iconSize: 30,
        ),
      ),
      body: _profilePage(context),
    );
  }

  Widget _profilePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileSection(context),
          const SizedBox(height: 20),
          Expanded(child: _recipesCreated()), // Display created recipes
        ],
      ),
    );
  }

  Widget _profileSection(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _showImageSelectionDialog(context);
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _profileImage != null
                ? AssetImage(_profileImage!)
                : const AssetImage("assets/images/placeholder_image.jpg")
                    as ImageProvider,
            child: _profileImage == null
                ? Center(
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Profile Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            final profileName = _nameController.text;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile saved: $profileName')),
            );
          },
          child: const Text('Save Profile'),
        ),
      ],
    );
  }

  void _showImageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              children: [
                _buildImageOption('assets/images/sad_image.png'),
                _buildImageOption('assets/images/sad_image.png'),
                _buildImageOption('assets/images/sad_image.png'),
                _buildImageOption('assets/images/sad_image.png'),
                _buildImageOption('assets/images/sad_image.png'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOption(String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _profileImage = imagePath;
        });
        Navigator.of(context).pop();
      },
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }

  Widget _userActivity() {
    return const Column(
      children: [
        Column(
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(child: Text("Kitchen Activity")),
                      Tab(child: Text("Recipes Created")),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        Card(
                          child: Center(child: Text("Kitchen Activity")),
                        ),
                        Card(
                          child: Center(child: Text("Recipes Created")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _recipesCreated() {
    return BlocBuilder<CreateRecipeQubit, List<CloudRecipe>>(
      builder: (context, recipes) {
        if (recipes.isEmpty) {
          return const Center(child: Text("No recipes created"));
        }
        return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                title: Text(recipe.recipeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(recipe.recipeDescription!),
                trailing: IconButton(
                  icon: const Icon(Icons.share, color: Colors.grey),
                  onPressed: () {
                    Share.share("Check out this recipe: ${recipe.recipeName}\n\n${recipe.recipeDescription}");
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
