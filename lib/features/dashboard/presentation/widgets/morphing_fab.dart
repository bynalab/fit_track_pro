import 'package:flutter/material.dart';

class MorphingFAB extends StatefulWidget {
  const MorphingFAB({super.key});

  @override
  State<MorphingFAB> createState() => _MorphingFABState();
}

class _MorphingFABState extends State<MorphingFAB> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isExpanded = !isExpanded);
        Navigator.pushNamed(context, '/workout');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(isExpanded ? 16 : 50),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isExpanded
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stop),
                    SizedBox(width: 8),
                    Text('Stop')
                  ],
                )
              : const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
