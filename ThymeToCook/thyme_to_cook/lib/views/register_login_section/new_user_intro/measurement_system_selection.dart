import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';

class MeasurementSystemSelection extends StatelessWidget {
  final Function(String) onMeasurementSelected;
  const MeasurementSystemSelection(
      {super.key, required this.onMeasurementSelected,  });

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
              ListView(
                children: [
                  ListTile(
                    title: const Text('Metric'),
                    leading:Radio(value:'metric',
                    groupValue: null,onChanged: (value){onMeasurementSelected(value!);},)
                    //onTap: () => onMeasurementSelected('metric'),
                  ),
                  ListTile(
                    title: const Text('Imperial'),
                    onTap: () => onMeasurementSelected('imperial'),
                  )
                ],
              )
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
