import 'package:flutter/material.dart';
import 'package:thyme_to_cook/services/cloud/cloud_recipes/cloud_recipe.dart';
import 'dart:async';

class CookWithMeView extends StatefulWidget {
  final List<RecipeInstructions> instructions;

  const CookWithMeView({Key? key, required this.instructions}) : super(key: key);

  @override
  _CookWithMeViewState createState() => _CookWithMeViewState();
}

class _CookWithMeViewState extends State<CookWithMeView> {
  int _currentStepIndex = 0;
  Timer? _timer;
  int _remainingTime = 0;

  void _startTimer(int seconds) {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _remainingTime = seconds;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer!.cancel();
        }
      });
    });
  }

  void _nextStep() {
    if (_currentStepIndex < widget.instructions.length - 1) {
      setState(() {
        _currentStepIndex++;
        _startTimerIfNeeded();
      });
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        _startTimerIfNeeded();
      });
    }
  }

  void _startTimerIfNeeded() {
    final currentInstruction = widget.instructions[_currentStepIndex];
    if (currentInstruction.time != null && currentInstruction.unit != null) {
      int timeInSeconds = currentInstruction.unit == 'minutes'
          ? currentInstruction.time! * 60
          : currentInstruction.unit == 'hours'
              ? currentInstruction.time! * 3600
              : currentInstruction.time!;
      _startTimer(timeInSeconds);
    } else {
      setState(() {
        _remainingTime = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentInstruction = widget.instructions[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cook With Me"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentInstruction.instruction!,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_remainingTime > 0)
              Text(
                "Time remaining: ${_remainingTime ~/ 60}m ${_remainingTime % 60}s",
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStepIndex > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousStep,
                    iconSize: 36,
                  ),
                if (_currentStepIndex < widget.instructions.length - 1)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _nextStep,
                    iconSize: 36,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
