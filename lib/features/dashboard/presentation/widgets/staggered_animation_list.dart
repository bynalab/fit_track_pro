import 'package:flutter/material.dart';

class StaggeredAnimationList extends StatefulWidget {
  final List<Widget> children;
  final Axis direction;

  const StaggeredAnimationList({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
  });

  @override
  State<StaggeredAnimationList> createState() => _StaggeredAnimationListState();
}

class _StaggeredAnimationListState extends State<StaggeredAnimationList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.children.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    }).toList();

    _runStaggered();
  }

  void _runStaggered() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: i * 150),
        () => _controllers[i].forward(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.direction,
      children: List.generate(
        widget.children.length,
        (index) {
          return ScaleTransition(
            scale: _animations[index],
            child: widget.children[index],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }

    super.dispose();
  }
}
