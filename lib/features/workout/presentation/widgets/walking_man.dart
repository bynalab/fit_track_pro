import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WalkingMan extends StatefulWidget {
  final bool isAnimating;

  const WalkingMan({
    super.key,
    this.isAnimating = true,
  });

  @override
  State<WalkingMan> createState() => _WalkingManState();
}

class _WalkingManState extends State<WalkingMan>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _compositionLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(WalkingMan oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating && _compositionLoaded) {
      if (widget.isAnimating) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/walking_man.json',
      width: 40,
      height: 40,
      controller: _controller,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _compositionLoaded = true;

        if (widget.isAnimating) {
          _controller.repeat();
        }
      },
    );
  }
}
