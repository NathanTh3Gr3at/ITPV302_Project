import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/main.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/measurement_system_selection.dart';

class DietarySelection extends StatefulWidget {
  const DietarySelection({
    super.key,
  });

  @override
  State<DietarySelection> createState() => _DietarySelectionState();
}

class _DietarySelectionState extends State<DietarySelection> {
  bool isVeganSelected = false;

  bool isPaleoSelected = false;

  bool isKetoSelected = false;

  bool isLowCarbSelected = false;

  bool isVegetarianSelected = false;

  bool isLowFatSelected = false;

  bool isKosherSelected = false;

  @override
  Widget build(BuildContext context) {
    void skip() {
      context.read<AuthBloc>().add(const AuthEventRegisterMeasurementSystem());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MeasurementSystemSelection(),
        ),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedIn) {
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
            value: 3 / 4,  
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 162, 206, 100)),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Dietary Preference",
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
              //Buttons for selection in two rows of 3 buttons each
              //vegan paleo keto

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ListTile(
                    //   title: Text('none'),
                    //   leading: Radio(
                    //     value: 'none',
                    //     groupValue: null,
                    //     onChanged: (value) {
                    //       Provider.of<UserProvider>(context, listen: false).updateDiet();
                    //     },
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                            isVeganSelected = !isVeganSelected;
                          });
                        Provider.of<UserProvider>(context, listen: false).updateDiet("VEGAN");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isVeganSelected ? backgroundColor : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Vegan',
                        style: TextStyle(color: Colors.black),
                      ),
                    ), 
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isPaleoSelected = !isPaleoSelected;
                          });
                          Provider.of<UserProvider>(context, listen: false).updateDiet("PALEO");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isPaleoSelected ? backgroundColor : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          'Paleo',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                            isKetoSelected = !isKetoSelected;
                          });
                        Provider.of<UserProvider>(context, listen: false).updateDiet("KETO_FRIENDLY");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isKetoSelected ? backgroundColor : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Keto',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                //low-carb vegetarian
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                            isLowCarbSelected = !isLowCarbSelected;
                          });
                         Provider.of<UserProvider>(context, listen: false).updateDiet("LOW_CARB");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isLowCarbSelected ? backgroundColor : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Low Carb',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isVegetarianSelected = !isVegetarianSelected;
                          });
                           Provider.of<UserProvider>(context, listen: false).updateDiet("VEGETARIAN");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isVegetarianSelected ? backgroundColor : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          'Vegetarian',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //diary-free gluten-free
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                            isLowFatSelected = !isLowFatSelected;
                          });
                        Provider.of<UserProvider>(context, listen: false).updateDiet("LOW_FAT");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isLowFatSelected ? backgroundColor : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Low Fat',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isKosherSelected = !isKosherSelected;
                          });
                          Provider.of<UserProvider>(context, listen: false).updateDiet("KOSHER");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isKosherSelected ? backgroundColor : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          'Kosher',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeasurementSystemSelection(),
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
    )
    );
  }
}
