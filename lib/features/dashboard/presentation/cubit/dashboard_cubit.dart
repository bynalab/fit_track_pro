import 'dart:async';

import 'package:fit_track_pro/features/workout/domain/repository/i_workout_repository.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final IWorkoutRepository repository;

  DashboardCubit(this.repository) : super(DashboardState.initial()) {
    _loadDashboardData();
  }

  void updateStats(WorkoutStats stats) {
    emit(state.copyWith(stats: stats));
  }

  Future<void> _loadDashboardData() async {
    try {
      emit(state.copyWith(isLoading: true));

      final today = DateTime.now();
      final sessions = await repository.getSessions();
      final todaySessions = sessions.where(
        (s) {
          return s.date.year == today.year &&
              s.date.month == today.month &&
              s.date.day == today.day;
        },
      );

      final totalSteps = todaySessions.fold(0, (sum, s) => sum + s.stats.steps);
      final totalCalories = todaySessions.fold(
        0,
        (sum, s) => sum + s.stats.calories,
      );

      final totalBpm = todaySessions.fold(0, (sum, s) => sum + s.stats.bpm);

      updateStats(
        WorkoutStats(
          steps: totalSteps,
          bpm: totalBpm,
          calories: totalCalories,
        ),
      );

      emit(state.copyWith(
        stats: WorkoutStats(
          steps: totalSteps,
          bpm: totalBpm,
          calories: totalCalories,
        ),
        sessions: sessions,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void refresh() => _loadDashboardData();
}
