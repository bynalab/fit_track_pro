// custom_chart.dart (tooltip with fade animation, scrollable chart, live updates ready)
import 'package:flutter/material.dart';
import 'chart_toggle.dart';
import 'chart_painters/bar_chart_painter.dart';
import 'chart_painters/line_chart_painter.dart';

enum MetricType { steps, calories, bpm }

class CustomChart extends StatefulWidget {
  final List<Map<String, int>> dataPoints;

  const CustomChart({super.key, required this.dataPoints});

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart>
    with SingleTickerProviderStateMixin {
  ChartType _chartType = ChartType.line;
  MetricType _metric = MetricType.steps;
  int? _tappedIndex;
  double? _chartWidth;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metricKey = _metric.name;
    final data = widget.dataPoints.map((e) => e[metricKey] ?? 0).toList();
    const chartHeight = 220.0;

    final screenWidth = MediaQuery.of(context).size.width;
    _chartWidth = data.length < 10 ? screenWidth : data.length * 40.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: MetricType.values
              .map((m) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(m.name.toUpperCase()),
                      selected: _metric == m,
                      onSelected: (_) => setState(() => _metric = m),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        ChartToggle(
          selected: _chartType,
          onChanged: (type) => setState(() => _chartType = type),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GestureDetector(
            onTapUp: (details) {
              final localDx = details.localPosition.dx;
              final itemWidth = _chartWidth! / data.length;
              final index =
                  (localDx / itemWidth).floor().clamp(0, data.length - 1);
              setState(() => _tappedIndex = index);
              _fadeController.forward(from: 0);
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Stack(
                key: ValueKey(_chartType.toString() + _metric.toString()),
                children: [
                  SizedBox(
                    height: chartHeight,
                    width: _chartWidth,
                    child: CustomPaint(
                      painter: _chartType == ChartType.line
                          ? LineChartPainter(data)
                          : BarChartPainter(data),
                    ),
                  ),
                  if (_tappedIndex != null && _tappedIndex! < data.length)
                    Positioned(
                      left: _tappedIndex! * (_chartWidth! / data.length) - 20,
                      top: 4,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${data[_tappedIndex!]}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
