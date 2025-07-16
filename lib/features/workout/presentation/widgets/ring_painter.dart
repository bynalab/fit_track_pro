import 'package:flutter/material.dart';

class RingPainter extends CustomPainter {
  final double progress;

  RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final progressPaint = Paint()
      ..shader = const LinearGradient(colors: [Colors.cyan, Colors.blue])
          .createShader(
              Rect.fromCircle(center: Offset.zero, radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      progress * 6.28,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class AnimatedRing extends StatelessWidget {
  final double progress;
  final AnimationController controller;

  const AnimatedRing({
    super.key,
    required this.progress,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final scale = 1 + (controller.value * 0.05);
        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            painter: RingPainter(progress: progress),
            child: const SizedBox(width: 200, height: 200),
          ),
        );
      },
    );
  }
}
