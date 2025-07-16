import 'dart:async';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';
import 'package:flutter/services.dart';
import '../../domain/repository/i_workout_repository.dart';

class WorkoutMemoryRepository implements IWorkoutRepository {
  static const _eventChannel = EventChannel('com.fittrack/workoutStream');
  static const _channel = MethodChannel('workout_channel');

  final List<WorkoutSession> _sessions = [];

  @override
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

  @override
  Future<void> resetStatsStream() async {
    await _channel.invokeMethod('resetStats');
  }

  @override
  Future<void> saveSession(WorkoutSession session) async {
    _sessions.add(session);
  }

  @override
  Future<List<WorkoutSession>> getSessions() async {
    return _sessions;
  }
}
