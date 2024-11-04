import 'package:flutter/material.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:intl/intl.dart';

class MealPannerView extends StatefulWidget {
  const MealPannerView({super.key});

  @override
  State<MealPannerView> createState() => _MealPannerViewState();
}

class _MealPannerViewState extends State<MealPannerView> with  SingleTickerProviderStateMixin{
   DateTime _currentDate = DateTime.now();

  String get _displayWeek {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    final currentStartOfWeek = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
    final currentEndOfWeek = currentStartOfWeek.add(const Duration(days: 6));

    if (currentStartOfWeek.isAtSameMomentAs(startOfWeek)) {
      return 'This Week';
    } else if (currentStartOfWeek.isAtSameMomentAs(startOfWeek.subtract(const Duration(days: 7)))) {
      return 'Last Week';
    } else {
      final formatter = DateFormat('dd MMM');
      return '${formatter.format(currentStartOfWeek)} - ${formatter.format(currentEndOfWeek)}';
    }
  }

   void _previousWeek() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 7));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Meal Planner",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
      ),
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _previousWeek,
              ),
              Text(
                _displayWeek,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: _nextWeek,
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text('Meal Planner Body Here'),
      ),
    );
  }
}

