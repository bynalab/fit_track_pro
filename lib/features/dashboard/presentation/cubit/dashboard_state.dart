import 'package:equatable/equatable.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';

class DashboardState extends Equatable {
  final WorkoutStats stats;
  final bool isLoading;

  const DashboardState({required this.stats, this.isLoading = false});

  static DashboardState initial() {
    return DashboardState(stats: WorkoutStats(steps: 0, bpm: 0, calories: 0));
  }

  DashboardState copyWith({WorkoutStats? stats, bool? isLoading}) {
    return DashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [stats, isLoading];
}
