import 'package:flutter/material.dart';

enum ChartType { line, bar }

class ChartToggle extends StatelessWidget {
  final ChartType selected;
  final ValueChanged<ChartType> onChanged;

  const ChartToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ChartType.values.map((type) {
        final isSelected = type == selected;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ChoiceChip(
            label: Text(type.name.toUpperCase()),
            selected: isSelected,
            onSelected: (_) => onChanged(type),
          ),
        );
      }).toList(),
    );
  }
}
