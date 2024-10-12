import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class MeasurementSystemSelection extends StatefulWidget {
  const MeasurementSystemSelection({super.key});

  @override
  State<MeasurementSystemSelection> createState() =>
      _MeasurementSystemSelectionState();
}

// Zanele - Add the bloc stuff for the measurement system thing
class _MeasurementSystemSelectionState
    extends State<MeasurementSystemSelection> {
  int _selectedMeasurementSystem = 1; // 1 for Metric, 2 for Imperial
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: 1,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ),
        body: Stack(children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Measurement System",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              //Just to add space between the radio buttons and the title
              const SizedBox(
                height: 80,
              ),
              ListTile(
                title: const Text('Metric'),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _selectedMeasurementSystem,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedMeasurementSystem = value!;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ),
              ListTile(
                title: const Text('Imperial'),
                leading: Radio<int>(
                  value: 2,
                  groupValue: _selectedMeasurementSystem,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedMeasurementSystem = value!;
                    });
                  },
                  activeColor: Colors.blue,
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
                  'Done',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ]));
  }
}
