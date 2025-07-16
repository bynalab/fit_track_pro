import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  final List<int> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.pink
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double step = size.width / (data.length - 1);
    final maxVal = data.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final x = step * i;
      final y = size.height * (1 - data[i] / maxVal);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return data != oldDelegate.data;
  }
}
