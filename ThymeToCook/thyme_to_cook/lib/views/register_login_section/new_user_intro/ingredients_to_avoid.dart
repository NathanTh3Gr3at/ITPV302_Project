import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/dietary_selection.dart';

class IngredientsToAvoidSelection extends StatefulWidget {
  // final Function(String) onAllergenSelected;
  const IngredientsToAvoidSelection({
    super.key,
    // required this.onAllergenSelected,
  });

  @override
  State<IngredientsToAvoidSelection> createState() =>
      _IngredientsToAvoidSelectionState();
}

class _IngredientsToAvoidSelectionState
    extends State<IngredientsToAvoidSelection> {
  bool isEggSelected = false;
  bool isPeanutsSelected = false;
  bool isFishSelected = false;
  bool isMilkSelected = false;
  bool isGlutenSelected = false;
  bool isMustardSelected = false;
  bool isAlcoholSelected = false;
  bool isDairySelected = false;

  @override
  Widget build(BuildContext context) {
    void skip() {
      context.read<AuthBloc>().add(const AuthEventRegisterDiets());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DietarySelection(),
        ),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegisterEmailAndPassword) {
          // Handle specific registration errors if needed
        } else if (state is AuthStateLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigation(isLoggedIn: true),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              MdiIcons.chevronLeft,
            ),
            iconSize: 35,
          ),
          leadingWidth: 40,
          actions: [
            TextButton(
              onPressed: skip,
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: 2 / 4,
              backgroundColor: Colors.grey,
              valueColor:
                  AlwaysStoppedAnimation(Color.fromARGB(255, 162, 206, 100)),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Ingredients to Avoid",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                 
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEggSelected = !isEggSelected;
                            });
                            
                            Provider.of<UserProvider>(context, listen: false)
                                .updateAllergens("EGG_FREE");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isEggSelected
                                  ? secondaryButtonColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            'Egg',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isPeanutsSelected = !isPeanutsSelected;
                              });

                              Provider.of<UserProvider>(context, listen: false)
                                  .updateAllergens("PEANUT_FREE");
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: isPeanutsSelected
                                    ? secondaryButtonColor
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              'Peanuts',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFishSelected = !isFishSelected;
                            });

                            Provider.of<UserProvider>(context, listen: false)
                                .updateAllergens("FISH_FREE");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isFishSelected
                                  ? secondaryButtonColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            'Fish',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isMilkSelected = !isMilkSelected;
                            });
                            Provider.of<UserProvider>(context, listen: false)
                                .updateAllergens("MILK_FREE");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isMilkSelected
                                ? secondaryButtonColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Milk',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isGlutenSelected = !isGlutenSelected;
                              });
                              Provider.of<UserProvider>(context, listen: false)
                                  .updateAllergens("GLUTEN_FREE");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isGlutenSelected
                                  ? secondaryButtonColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Gluten',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isMustardSelected = !isMustardSelected;
                            });
                            Provider.of<UserProvider>(context, listen: false)
                                .updateAllergens("MUSTARD_FREE");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isMustardSelected
                                ? secondaryButtonColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Mustard',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isAlcoholSelected = !isAlcoholSelected;
                            });
                            Provider.of<UserProvider>(context, listen: false)
                                .updateAllergens("ALCOHOL_FREE");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isAlcoholSelected
                                  ? secondaryButtonColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            'Alcohol',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isDairySelected = !isDairySelected;
                            });
                            Provider.of<UserProvider>(context, listen: false)
                                .updateAllergens("DAIRY_FREE");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isDairySelected
                                  ? secondaryButtonColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            'Dairy',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DietarySelection(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
