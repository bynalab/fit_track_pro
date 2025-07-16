import 'package:flutter/material.dart';

class BarChartPainter extends CustomPainter {
  final List<int> data;

  BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.teal;
    final barWidth = size.width / (data.length * 2);
    final maxVal = data.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final left = i * 2 * barWidth;
      final top = size.height * (1 - data[i] / maxVal);
      final rect = Rect.fromLTWH(left, top, barWidth, size.height - top);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) {
    return data != oldDelegate.data;
  }
}
