import 'dart:convert';

class WorkoutStats {
  final int steps;
  final int bpm;
  final int calories;

  WorkoutStats({
    required this.steps,
    required this.bpm,
    required this.calories,
  });

  WorkoutStats copyWith({
    int? steps,
    int? bpm,
    int? calories,
  }) {
    return WorkoutStats(
      steps: steps ?? this.steps,
      bpm: bpm ?? this.bpm,
      calories: calories ?? this.calories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'bpm': bpm,
      'calories': calories,
    };
  }

  factory WorkoutStats.fromMap(Map<String, dynamic> map) {
    return WorkoutStats(
      steps: map['steps']?.toInt() ?? 0,
      bpm: map['bpm']?.toInt() ?? 0,
      calories: map['calories']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutStats.fromJson(String source) =>
      WorkoutStats.fromMap(json.decode(source));

  @override
  String toString() =>
      'WorkoutStats(steps: $steps, bpm: $bpm, calories: $calories)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutStats &&
        other.steps == steps &&
        other.bpm == bpm &&
        other.calories == calories;
  }

  @override
  int get hashCode => steps.hashCode ^ bpm.hashCode ^ calories.hashCode;
}
