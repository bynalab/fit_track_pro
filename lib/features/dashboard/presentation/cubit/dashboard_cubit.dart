import 'dart:async';

import 'package:fit_track_pro/features/dashboard/data/workout_repository.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final WorkoutRepository repository;
  // final NotificationService notifications;

  DashboardCubit(this.repository) : super(DashboardState.initial());

  StreamSubscription? _statsSubscription;

  void updateStats(WorkoutStats stats) {
    emit(state.copyWith(stats: stats));
  }

  void startListeningToStats() {
    _statsSubscription?.cancel();
    _statsSubscription = repository.getWorkoutStatsStream().listen((stats) {
      updateStats(stats);
    });
  }

  @override
  Future<void> close() {
    _statsSubscription?.cancel();
    return super.close();
  }
}
