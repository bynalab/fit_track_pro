part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkout extends WorkoutEvent {}

class PauseWorkout extends WorkoutEvent {}

class SkipWorkout extends WorkoutEvent {}

class ResumeWorkout extends WorkoutEvent {
  final int elapsed;
  const ResumeWorkout({required this.elapsed});

  @override
  List<Object?> get props => [elapsed];
}

class EndWorkout extends WorkoutEvent {}
