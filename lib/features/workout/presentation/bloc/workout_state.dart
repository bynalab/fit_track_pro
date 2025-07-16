part of 'workout_bloc.dart';

abstract class WorkoutState extends Equatable {
  final WorkoutStats? stats;

  const WorkoutState({this.stats});

  @override
  List<Object?> get props => [stats];
}

class WorkoutInitial extends WorkoutState {
  const WorkoutInitial({super.stats});

  WorkoutInitial copyWith({WorkoutStats? stats}) {
    return WorkoutInitial(stats: stats ?? this.stats);
  }
}

class WorkoutInProgress extends WorkoutState {
  final int elapsed;

  const WorkoutInProgress({required this.elapsed, super.stats});

  WorkoutInProgress copyWith({int? elapsed, WorkoutStats? stats}) {
    return WorkoutInProgress(
      elapsed: elapsed ?? this.elapsed,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [elapsed, stats];
}

class WorkoutPaused extends WorkoutState {
  final int elapsed;

  const WorkoutPaused({required this.elapsed, super.stats});

  WorkoutPaused copyWith({int? elapsed, WorkoutStats? stats}) {
    return WorkoutPaused(
      elapsed: elapsed ?? this.elapsed,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [elapsed, stats];
}

class WorkoutSkipped extends WorkoutState {
  final int elapsed;

  const WorkoutSkipped({required this.elapsed, super.stats});

  WorkoutSkipped copyWith({int? elapsed, WorkoutStats? stats}) {
    return WorkoutSkipped(
      elapsed: elapsed ?? this.elapsed,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [elapsed, stats];
}

class WorkoutCompleted extends WorkoutState {
  const WorkoutCompleted({super.stats});

  WorkoutCompleted copyWith({WorkoutStats? stats}) {
    return WorkoutCompleted(stats: stats ?? this.stats);
  }
}
