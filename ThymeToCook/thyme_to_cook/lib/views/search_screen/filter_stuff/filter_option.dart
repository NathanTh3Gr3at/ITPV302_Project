import 'package:flutter/material.dart';

class FilterOption extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String>? selectedOptions;
  final Function(List<String>)onSelected;

  const FilterOption({super.key, required this.label, required this.options, required this.onSelected, required this.selectedOptions});

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.selectedOptions!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: widget.options.map((option) {
            final bool isSelected = selectedOptions.contains(option);
            return FilterChip(
              shape: const StadiumBorder(),
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                  selectedOptions.add(option);
                } else {
                  selectedOptions.remove(option);
                }
                });
                widget.onSelected(selectedOptions);
              },
              // Change color to the one needed!!
              selectedColor: Colors.green,
              showCheckmark: false,
            );
          }).toList(),
        )
      ]
    );
  }
}