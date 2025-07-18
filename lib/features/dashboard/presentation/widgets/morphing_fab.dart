import 'dart:ui';
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(icon),
          label: Text(label),
          onPressed: onPressed,
        ),
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        Positioned(
          bottom: 100,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isExpanded) ...[
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
                _buildMenuOption(
                  icon: Icons.settings,
                  label: 'Settings',
                  onPressed: () {
                    toggleMenu();
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: FloatingActionButton(
            backgroundColor: Colors.tealAccent.shade100,
            onPressed: toggleMenu,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isExpanded ? Icons.close : Icons.add,
                color: Colors.black,
                key: ValueKey(isExpanded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
