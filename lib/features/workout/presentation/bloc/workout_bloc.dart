import 'package:fit_track_pro/core/services/notification_service.dart';
import 'package:fit_track_pro/core/utils/formatter.dart';
import 'package:fit_track_pro/features/workout/domain/repository/i_workout_repository.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/data/services/workout_timer_service.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final IWorkoutRepository repository;
  final WorkoutTimerService _timerService;
  final NotificationService notifications;

  StreamSubscription? _statsSubscription;

  WorkoutBloc(this.repository, this._timerService, this.notifications)
      : super(const WorkoutInitial()) {
    on<StartWorkout>(_onStart);
    on<PauseWorkout>(_onPause);
    on<SkipWorkout>(_onSkip);
    on<ResumeWorkout>(_onResume);
    on<EndWorkout>(_onEnd);
    on<UpdateStats>(_onUpdateStats);
    on<Tick>(_onTick);
  }

  void _onStart(StartWorkout event, Emitter<WorkoutState> emit) {
    repository.resetStatsStream();
    _startListeningToStats();

    _timerService.start((seconds) {
      add(Tick(elapsed: seconds));

      try {
        notifications.showWorkoutProgress(
          id: 1,
          title: 'Workout in progress',
          body: 'Elapsed time: ${formatElapsedTime(seconds)}',
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    emit(const WorkoutInProgress(elapsed: 0));
  }

  void _onPause(PauseWorkout event, Emitter<WorkoutState> emit) {
    _timerService.pause();
    notifications.cancel(1).catchError(onError);
    _stopListeningToStats();

    if (state.stats != null) {
      add(UpdateStats(state.stats!));
    }

    emit(WorkoutPaused(elapsed: _timerService.elapsed));
  }

  void _onResume(ResumeWorkout event, Emitter<WorkoutState> emit) {
    _startListeningToStats();
    _timerService.resume();

    notifications
        .showWorkoutProgress(
          id: 1,
          title: 'Workout resumed',
          body: 'Elapsed time: ${formatElapsedTime(_timerService.elapsed)}',
        )
        .catchError(onError);

    emit(WorkoutInProgress(elapsed: _timerService.elapsed));
  }

  void _onSkip(SkipWorkout event, Emitter<WorkoutState> emit) {
    _timerService.pause();
    notifications.cancel(1).catchError(onError);
    emit(WorkoutSkipped(elapsed: _timerService.elapsed));
  }

  void _onEnd(EndWorkout event, Emitter<WorkoutState> emit) async {
    _timerService.stop();
    await _stopListeningToStats();
    await notifications.cancel(1).catchError(onError);
    await repository.resetStatsStream();

    await repository.saveSession(
      WorkoutSession(
        date: DateTime.now(),
        stats: WorkoutStats(
          steps: state.stats?.steps ?? 0,
          calories: state.stats?.calories ?? 0,
          bpm: state.stats?.bpm ?? 0,
        ),
        duration: _timerService.elapsed,
      ),
    );

    emit(const WorkoutCompleted());
  }

  void _onUpdateStats(UpdateStats event, Emitter<WorkoutState> emit) {
    final current = state;

    if (current is WorkoutInProgress) {
      emit(current.copyWith(stats: event.stats));
    } else if (current is WorkoutPaused) {
      emit(current.copyWith(stats: event.stats));
    } else if (current is WorkoutSkipped) {
      emit(current.copyWith(stats: event.stats));
    } else if (current is WorkoutInitial) {
      emit(current.copyWith(stats: event.stats));
    } else if (current is WorkoutCompleted) {
      emit(current.copyWith(stats: event.stats));
    }
  }

  void _onTick(Tick event, Emitter<WorkoutState> emit) {
    if (state is! WorkoutCompleted) {
      emit(WorkoutInProgress(elapsed: event.elapsed));
    }
  }

  void _startListeningToStats() {
    _statsSubscription?.cancel();
    _statsSubscription =
        repository.getWorkoutStatsStream().listen((incomingStats) {
      add(UpdateStats(incomingStats));
    });
  }

  Future<void> _stopListeningToStats() async {
    await _statsSubscription?.cancel();
    _statsSubscription = null;
  }

  @override
  Future<void> close() async {
    await _stopListeningToStats();
    _timerService.dispose();
    await notifications.cancel(1).catchError(onError);
    return super.close();
  }
}
