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

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: isSelected
              ? (Matrix4.identity()..scale(1.1))
              : Matrix4.identity(),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: isSelected
              ? BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                )
              : null,
          child: ChoiceChip(
            label: Text(
              type.name.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.grey[300],
                letterSpacing: 1.2,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onChanged(type),
            backgroundColor: Colors.grey[850],
            selectedColor: Colors.transparent,
            elevation: isSelected ? 6 : 2,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: isSelected
                  ? BorderSide.none
                  : BorderSide(color: Colors.grey[700]!),
            ),
            avatar: isSelected
                ? Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  )
                : null,
            shadowColor: Colors.black87,
            selectedShadowColor: Colors.pinkAccent.withValues(alpha: 0.5),
            clipBehavior: Clip.antiAlias,
            labelPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            pressElevation: 8,
          ),
        );
      }).toList(),
    );
  }
}
