import 'package:fit_track_pro/core/services/notification_service.dart';
import 'package:fit_track_pro/features/workout/data/services/workout_timer_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutTimerService _timerService;
  final NotificationService notifications;

  WorkoutBloc(this._timerService, this.notifications)
      : super(const WorkoutInitial()) {
    on<StartWorkout>(_onStart);
    on<PauseWorkout>(_onPause);
    on<SkipWorkout>(_onSkip);
    on<ResumeWorkout>(_onResume);
    on<EndWorkout>(_onEnd);
    on<Tick>(_onTick);
  }

  void _onStart(StartWorkout event, Emitter<WorkoutState> emit) {
    _timerService.start((seconds) {
      add(Tick(elapsed: seconds));

      notifications.showWorkoutProgress(
        id: 1,
        title: 'Workout in progress',
        body: 'Elapsed time: ${(seconds)}',
      );
    });
    emit(const WorkoutInProgress(elapsed: 0));
  }

  void _onPause(PauseWorkout event, Emitter<WorkoutState> emit) {
    _timerService.pause();
    notifications.cancel(1);
    emit(WorkoutPaused(elapsed: _timerService.elapsed));
  }

  void _onResume(ResumeWorkout event, Emitter<WorkoutState> emit) {
    _timerService.resume();
    emit(WorkoutInProgress(elapsed: _timerService.elapsed));
  }

  void _onSkip(SkipWorkout event, Emitter<WorkoutState> emit) {
    _timerService.pause();
    emit(WorkoutSkipped(elapsed: _timerService.elapsed));
  }

  void _onEnd(EndWorkout event, Emitter<WorkoutState> emit) {
    _timerService.stop();
    notifications.cancel(1);
    emit(const WorkoutCompleted());
  }

  void _onTick(Tick event, Emitter<WorkoutState> emit) {
    emit(WorkoutInProgress(elapsed: event.elapsed));
  }

  @override
  Future<void> close() {
    _timerService.dispose();
    return super.close();
  }
}
