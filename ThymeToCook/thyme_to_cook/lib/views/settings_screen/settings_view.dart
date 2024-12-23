import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/utilities/dialogs/logout_dialog.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/settings_forgot_password_view.dart';

class SettingsView extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
 
  
  String? _selectedMeasurementUnit;
  //need to fix overflow error (bottom overflow)
  final Map<String, bool> _ingredients = {
    'Egg': false,
    'Caffeine': false,
    'Fish': false,
    'Milk': false,
    'Gluten': false,
    'Mustard': false
  };
  final Map<String, bool> _diets = {
    'Vegan': false,
    'Paleo': false,
    'Keto': false,
    'Low Carb': false,
    'Vegetarian': false,
    'Diary free': false,
    'Gluten free': false
  };
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    //load measurement
    _selectedMeasurementUnit = prefs.getString('measurement_preference');
    //load Diet
    String? dietsString = prefs.getString('diet_preferences');
    if (dietsString != null) {
      List<String> savedDiets = dietsString.split(',');
      _diets.updateAll((key, value) => savedDiets.contains(key));
    }
    //load Allergens
    String? allergenString = prefs.getString('allergen_preferences');
    if (allergenString != null) {
      List<String> savedAllergens = allergenString.split(',');
      _ingredients.updateAll((key, value) => savedAllergens.contains(key));
    }
    setState(() {});
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('measurement_preference', _selectedMeasurementUnit!);
    List<String> selectedDiets = _diets.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    await prefs.setString('diet_preferences', selectedDiets.join(','));
    List<String> selectedAllergens = _ingredients.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    await prefs.setString('allergen_preferences', selectedAllergens.join(','));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,

        title: const Text("Settings"),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(MdiIcons.chevronLeft),
          iconSize: 30,
        ),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Account Section
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock,
                  size: 30,
                ),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password'),
                trailing: TextButton(
                  onPressed: () {
                    /* context.read()<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        ); */
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>const SettingsForgotPasswordView()));
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const Divider(),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.straighten,
                  size: 30,
                ),
                title: const Text('Measurement Units'),
                subtitle: const Text('Select your preferred units'),
                trailing: DropdownButton<String>(
                  value: _selectedMeasurementUnit,
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        _selectedMeasurementUnit = newValue!;
                      },
                    );
                    _savePreferences();
                  },
                  items: <String>['Metric', 'Imperial']
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
              ExpansionTile(
                leading: const Icon(
                  Icons.food_bank,
                  size: 30,
                ),
                title: const Text('Dietary Preferences'),
                subtitle: const Text('Select your Dietary Preferences'),
                children: _diets.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _diets[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _diets[key] = value!;
                      });
                      _savePreferences();
                    },
                  );
                }).toList(),
              ),
              ExpansionTile(
                leading: const Icon(
                  Icons.warning,
                  size: 30,
                ),
                title: const Text('Ingredients to Avoid'),
                subtitle: const Text('Select Ingredients'),
                children: _ingredients.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _ingredients[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _ingredients[key] = value!;
                      });
                      _savePreferences();
                    },
                  );
                }).toList(),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Log Out'),
                trailing: TextButton(
                  onPressed: () async {
                    final shouldLogOut = await showLogOutDialog(context);
                    if (shouldLogOut) {
                        context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(isLoggedIn: false,),
                      ),
                  );
                  }
                  },
                  child: const Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 

