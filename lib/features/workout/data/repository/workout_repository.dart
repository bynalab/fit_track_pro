import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';
import 'package:fit_track_pro/features/workout/domain/repository/i_workout_repository.dart';

class WorkoutRepository implements IWorkoutRepository {
  static const _channel = MethodChannel('workout_channel');
  static const _eventChannel = EventChannel('com.fittrack/workoutStream');
  static const _sessionsKey = 'workout_sessions';

  List<WorkoutSession> _sessions = [];

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
    final prefs = await SharedPreferences.getInstance();
    _sessions.add(session);
    final encoded = _sessions.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_sessionsKey, encoded);
  }

  @override
  Future<List<WorkoutSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_sessionsKey) ?? [];

    _sessions =
        encoded.map((e) => WorkoutSession.fromJson(json.decode(e))).toList();

    return _sessions;
  }
}
