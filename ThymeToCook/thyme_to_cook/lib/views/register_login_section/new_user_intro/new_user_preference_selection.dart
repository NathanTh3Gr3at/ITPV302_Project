import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/dietary_selection.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/ingredients_to_avoid.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/measurement_system_selection.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
 

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  
  List<String> _selectedDiets = [];
  String? _selectedMeasurement;
  final List<String> _diets = ['Vegan', 'Vegetarian', 'Keto', 'Paleo'];
  final List<String> _measurements = ['Metric', 'Imperial'];
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? dietsString = prefs.getString('diet_preferences');
    if (dietsString != null) {
      _selectedDiets = dietsString.split(',');
    }
    _selectedMeasurement = prefs.getString('measurement_preference');
    setState(() {});
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String dietsString = _selectedDiets.join(',');
    await prefs.setString('diet_preferences', dietsString);
    await prefs.setString('measurement_preference', _selectedMeasurement!);
    await prefs.setBool('preferences_set', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          builder: (context) => MainNavigation()));
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


 /* class PreferencesScreen extends StatefulWidget {
  final PreferencesService preferencesService;
  const PreferencesScreen({super.key, required this.preferencesService});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  PageController _pageController = PageController();
  void _onDietSelected(String diet) async {
    await widget.preferencesService.savePreference('diet', diet);
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onAllergensSelected(String allergen) async {
    await widget.preferencesService.savePreference('allergen', allergen);
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onMeasurementSelected(String measurement) async {
    await widget.preferencesService.savePreference('measurement', measurement);
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainNavigation()));
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          IngredientsToAvoidSelection(onAllergenSelected: _onAllergensSelected),
          DietarySelection(onDietSelected: _onDietSelected),
          
          MeasurementSystemSelection(
              onMeasurementSelected: _onMeasurementSelected),
        ]);
  }
} */
 

/* class PreferencesScreen extends StatefulWidget {
  final PreferencesService preferencesService;
  const PreferencesScreen({super.key, required this.preferencesService});
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  int _currentStep = 0;
  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      widget.preferencesService.markPreferencesCompleted();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainNavigation()));
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preferences')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: [
          Step(
            title: Text("Dietary Selection"),
            content: DietarySelection(
              onDietSelected: (diet) async {
                await widget.preferencesService.savePreference('diet', diet);
                _onStepContinue();
              },
            ),isActive:_currentStep>=0,state:_currentStep>0?StepState.complete:StepState.indexed,
          ),
          Step(
            title: Text("Ingrediets To Avoid"),
            content: DietarySelection(
              onDietSelected: (allergen) async {
                await widget.preferencesService.savePreference('diet', allergen);
                _onStepContinue();
              },
            ),isActive:_currentStep>=1,state:_currentStep>0?StepState.complete:StepState.indexed,
          ),
          Step(
            title: Text("Measurement"),
            content: DietarySelection(
              onDietSelected: (measurement) async {
                await widget.preferencesService.savePreference('diet', measurement);
                _onStepContinue();
              },
            ),isActive:_currentStep>=2,state:_currentStep>0?StepState.complete:StepState.indexed,
          ),
        ],
      ),
    );
  }
}
 */