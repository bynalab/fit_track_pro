import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chart_toggle.dart';
import 'chart_painters/bar_chart_painter.dart';
import 'chart_painters/line_chart_painter.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';

enum MetricType { steps, calories, bpm }

class CustomChart extends StatefulWidget {
  final List<WorkoutSession> sessions;

  const CustomChart({super.key, required this.sessions});

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

  Map<DateTime, WorkoutStats> _groupSessionsByDay(
    List<WorkoutSession> sessions,
  ) {
    final Map<DateTime, WorkoutStats> grouped = {};

    for (final session in sessions) {
      final date = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );

      final existing = grouped[date];

      grouped[date] = WorkoutStats(
        steps: (existing?.steps ?? 0) + session.stats.steps,
        calories: (existing?.calories ?? 0) + session.stats.calories,
        bpm: session.stats.bpm,
      );
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupSessionsByDay(widget.sessions);
    final sortedDates = grouped.keys.toList()..sort();

    final data = sortedDates.map((date) {
      final stat = grouped[date]!;
      switch (_metric) {
        case MetricType.steps:
          return stat.steps;
        case MetricType.calories:
          return stat.calories;
        case MetricType.bpm:
          return stat.bpm;
      }
    }).toList();

    const chartHeight = 220.0;
    final screenWidth = MediaQuery.of(context).size.width;
    _chartWidth = data.length < 10 ? screenWidth : data.length * 40.0;

    return Column(
      children: [
        ChartToggle(
          selected: _chartType,
          onChanged: (type) => setState(() => _chartType = type),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: MetricType.values.map((m) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ChoiceChip(
                label: Text(m.name.toUpperCase()),
                selected: _metric == m,
                onSelected: (_) => setState(() => _metric = m),
              ),
            );
          }).toList(),
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
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${data[_tappedIndex!]} on ${DateFormat('MMM d').format(sortedDates[_tappedIndex!])}',
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
