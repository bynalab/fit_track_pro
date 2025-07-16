import 'package:equatable/equatable.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final WorkoutStats stats;
  final List<WorkoutSession> sessions;

  const DashboardState({
    this.isLoading = false,
    required this.stats,
    required this.sessions,
  });

  static DashboardState initial() {
    return DashboardState(
      stats: WorkoutStats(steps: 0, bpm: 0, calories: 0),
      sessions: const [],
    );
  }

  DashboardState copyWith({
    bool? isLoading,
    WorkoutStats? stats,
    List<WorkoutSession>? sessions,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object?> get props => [stats, isLoading];
}
