import 'package:equatable/equatable.dart';

class WorkoutStats extends Equatable {
  final int steps;
  final int calories;
  final int bpm;

  const WorkoutStats({this.steps = 0, this.calories = 0, this.bpm = 0});

  WorkoutStats copyWith({int? steps, int? calories, int? bpm}) => WorkoutStats(
        steps: steps ?? this.steps,
        calories: calories ?? this.calories,
        bpm: bpm ?? this.bpm,
      );

  @override
  List<Object?> get props => [steps, calories, bpm];
}
