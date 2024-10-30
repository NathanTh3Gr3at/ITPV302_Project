import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/measurement_system_selection.dart';

class IngredientsToAvoidSelection extends StatelessWidget {
  final Function(String) onAllergenSelected;
  const IngredientsToAvoidSelection({
    super.key,
    required this.onAllergenSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
       /*  bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ), */
      ),
      body: Stack(
        children: [
          Column(
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
                height: 100,
              ),
              //Buttons for selection in two rows of 3 buttons each
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text('Eggs'),
                        leading: Radio(
                          value: 'eggs',
                          groupValue: null,
                          onChanged: (value) {
                            onAllergenSelected(value!);
                          },
                        )),
                    /* ElevatedButton(
                      onPressed: () => onAllergenSelected('egg'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secodaryButtonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Egg',
                        style: TextStyle(color: Colors.black),
                      ),
                    ), */
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => onAllergenSelected('caffeine'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: secodaryButtonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          'Caffeine',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onAllergenSelected('fish'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secodaryButtonColor,
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
                      onPressed: () => onAllergenSelected('milk'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secodaryButtonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Milk',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => onAllergenSelected('gluten'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: secodaryButtonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          'Gluten',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onAllergenSelected('mustard'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secodaryButtonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        'Mustard',
                        style: TextStyle(color: Colors.black),
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
                  //nav to next screen
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
    );
  }
}
