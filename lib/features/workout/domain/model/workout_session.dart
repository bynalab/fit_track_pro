import 'dart:convert';

import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';

class WorkoutSession {
  final DateTime date;
  final WorkoutStats stats;
  final int duration; // in seconds

  WorkoutSession({
    required this.date,
    required this.stats,
    required this.duration,
  });

  WorkoutSession copyWith({
    DateTime? date,
    WorkoutStats? stats,
    int? duration,
  }) {
    return WorkoutSession(
      date: date ?? this.date,
      stats: stats ?? this.stats,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'stats': stats.toMap(),
      'duration': duration,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      stats: WorkoutStats.fromMap(map['stats']),
      duration: map['duration']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSession.fromJson(String source) =>
      WorkoutSession.fromMap(json.decode(source));

  @override
  String toString() =>
      'WorkoutSession(date: $date, stats: $stats, duration: $duration)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutSession &&
        other.date == date &&
        other.stats == stats &&
        other.duration == duration;
  }

  @override
  int get hashCode => date.hashCode ^ stats.hashCode ^ duration.hashCode;
}
