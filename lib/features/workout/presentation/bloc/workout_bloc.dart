import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  WorkoutBloc() : super(const WorkoutInitial()) {
    on<StartWorkout>(_onStart);
    on<PauseWorkout>(_onPause);
    on<SkipWorkout>(_onSkip);
    on<ResumeWorkout>(_onResume);
    on<EndWorkout>(_onEnd);
  }

  void _onStart(StartWorkout event, Emitter<WorkoutState> emit) {
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      add(ResumeWorkout(elapsed: _elapsedSeconds));
    });
    emit(WorkoutInProgress(elapsed: _elapsedSeconds));
  }

  void _onPause(PauseWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(WorkoutPaused(elapsed: _elapsedSeconds));
  }

  void _onSkip(SkipWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(WorkoutSkipped(elapsed: _elapsedSeconds));
  }

  void _onResume(ResumeWorkout event, Emitter<WorkoutState> emit) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      add(ResumeWorkout(elapsed: _elapsedSeconds));
    });
    emit(WorkoutInProgress(elapsed: event.elapsed));
  }

  void _onEnd(EndWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(const WorkoutCompleted());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
