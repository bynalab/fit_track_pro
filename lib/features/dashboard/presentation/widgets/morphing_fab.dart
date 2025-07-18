import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MorphingFABMenu extends StatefulWidget {
  const MorphingFABMenu({super.key});

  @override
  State<MorphingFABMenu> createState() => _MorphingFABMenuState();
}

class _MorphingFABMenuState extends State<MorphingFABMenu>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  void toggleMenu() {
    HapticFeedback.mediumImpact();
    setState(() => isExpanded = !isExpanded);
    isExpanded ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isExpanded)
          GestureDetector(
            onTap: toggleMenu,
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          bottom: isExpanded ? 80 : 20,
          right: 50,
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMenuOption(
                      icon: Icons.fitness_center,
                      label: 'Start Workout',
                      onPressed: () {
                        toggleMenu();
                        Navigator.pushNamed(context, '/workout');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuOption(
                      icon: Icons.history,
                      label: 'History',
                      onPressed: () {
                        toggleMenu();
                        Navigator.pushNamed(context, '/history');
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: toggleMenu,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isExpanded ? Icons.close : Icons.menu,
                key: ValueKey(isExpanded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
