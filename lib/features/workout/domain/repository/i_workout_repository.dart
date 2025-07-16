import 'dart:async';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';

abstract class IWorkoutRepository {
  Stream<WorkoutStats> getWorkoutStatsStream();
  Future<void> resetStatsStream();

  Future<void> saveSession(WorkoutSession session);
  Future<List<WorkoutSession>> getSessions();
}
