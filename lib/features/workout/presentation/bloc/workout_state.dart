part of 'workout_bloc.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
}

class WorkoutInProgress extends WorkoutState {
  final int elapsed;
  const WorkoutInProgress({required this.elapsed});

  @override
  List<Object?> get props => [elapsed];
}

class WorkoutPaused extends WorkoutState {
  final int elapsed;
  const WorkoutPaused({required this.elapsed});

  @override
  List<Object?> get props => [elapsed];
}

class WorkoutSkipped extends WorkoutState {
  final int elapsed;
  const WorkoutSkipped({required this.elapsed});

  @override
  List<Object?> get props => [elapsed];
}

class WorkoutCompleted extends WorkoutState {
  const WorkoutCompleted();
}
