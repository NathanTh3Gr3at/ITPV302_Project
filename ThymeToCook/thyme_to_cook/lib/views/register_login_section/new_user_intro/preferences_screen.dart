import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> _selectedDiets = [];
  List<String> _selectedIngredientsToAvoid = [];
  String? _selectedMeasurement;
  final List<String> _diets = [
    'None',
    'Vegan',
    'Vegetarian',
    'Keto',
    'Paleo',
    'low_carb',
    'gluten_free',
    'diary_free'
  ];
  final List<String> _ingredientsToAvoid = [
    'Eggs',
    'Caffeine',
    'Fish',
    'Milk',
    'Gluten',
    'Mustard'
  ];
  final List<String> _measurements = ['Metric', 'Imperial'];
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? dietsString = prefs.getString('diet_preferences');
    String? allergenString = prefs.getString('allergen_preferences');
    if (dietsString != null) {
      _selectedDiets = dietsString.split(',');
    }
    if (allergenString != null) {
      _selectedIngredientsToAvoid = allergenString.split(',');
    }

    _selectedMeasurement = prefs.getString('measurement_preference');
    setState(() {});
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String dietsString = _selectedDiets.join(',');
    String allergenString = _selectedIngredientsToAvoid.join(',');
    await prefs.setString('diet_preferences', dietsString);
    await prefs.setString('allergen_preferences', allergenString);
    await prefs.setString('measurement_preference', _selectedMeasurement!);
    await prefs.setBool('preferences_set', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select diets: ', style: TextStyle(fontSize: 18)),
            ..._diets.map((diet) => CheckboxListTile(
                  title: Text(diet),
                  value: _selectedDiets.contains(diet),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedDiets.add(diet);
                      } else {
                        _selectedDiets.remove(diet);
                      }
                    });
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            const Text('Select Ingredients To Avoid: ',
                style: TextStyle(fontSize: 18)),
            ..._ingredientsToAvoid.map((allergens) => CheckboxListTile(
                  title: Text(allergens),
                  value: _selectedIngredientsToAvoid.contains(allergens),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedIngredientsToAvoid.add(allergens);
                      } else {
                        _selectedIngredientsToAvoid.remove(allergens);
                      }
                    });
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            const Text('Select measurement: ', style: TextStyle(fontSize: 18)),
            ..._measurements.map((measurement) => RadioListTile(
                  title: Text(measurement),
                  value: measurement,
                  groupValue: _selectedMeasurement,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMeasurement = value;
                    });
                  },
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _savePreferences().then((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainNavigation(
                                isLoggedIn: true,
                              )));
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
