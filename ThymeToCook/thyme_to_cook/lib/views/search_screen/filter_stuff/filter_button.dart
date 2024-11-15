import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final int count;
  // Handles the tapping responsible for initiating the bottom filter modal screen
  final VoidCallback onTap;

  const FilterButton({super.key, required this.label, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Chip(
            label: Text(label),
            shape: const StadiumBorder(),
          ),
          if (count > 0) 
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green[300],
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12
                  ),
                )
              )
            )
        ]
      )
    );
  }
}