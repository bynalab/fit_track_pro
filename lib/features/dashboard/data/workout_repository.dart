import 'dart:async';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:flutter/services.dart';

class WorkoutRepository {
  static const _eventChannel = EventChannel('com.fittrack/workoutStream');
  static const _channel = MethodChannel('workout_channel');

  Stream<WorkoutStats> getWorkoutStatsStream() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      return WorkoutStats(
        steps: map['steps'] ?? 0,
        bpm: map['bpm'] ?? 0,
        calories: map['calories'] ?? 0,
      );
    });
  }

  Future<void> resetStats() async {
    await _channel.invokeMethod('resetStats');
  }
}
