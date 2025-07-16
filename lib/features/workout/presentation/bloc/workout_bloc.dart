import 'package:fit_track_pro/core/services/notification_service.dart';
import 'package:fit_track_pro/features/dashboard/data/workout_repository.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/data/services/workout_timer_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository repository;
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
    _startListeningToStats();

    _timerService.start((seconds) {
      add(Tick(elapsed: seconds));

      notifications.showWorkoutProgress(
        id: 1,
        title: 'Workout in progress',
        body: 'Elapsed time: $seconds sec',
      );
    });

    emit(const WorkoutInProgress(elapsed: 0));
  }

  void _onPause(PauseWorkout event, Emitter<WorkoutState> emit) {
    _timerService.pause();
    notifications.cancel(1);
    _stopListeningToStats();

    if (state.stats != null) {
      add(UpdateStats(state.stats!));
    }

    emit(WorkoutPaused(elapsed: _timerService.elapsed));
  }

  void _onResume(ResumeWorkout event, Emitter<WorkoutState> emit) {
    _startListeningToStats();
    _timerService.resume();

    notifications.showWorkoutProgress(
      id: 1,
      title: 'Workout resumed',
      body: 'Elapsed time: ${_timerService.elapsed} sec',
    );

    emit(WorkoutInProgress(elapsed: _timerService.elapsed));
  }

  void _onSkip(SkipWorkout event, Emitter<WorkoutState> emit) {
    _timerService.pause();
    notifications.cancel(1);
    emit(WorkoutSkipped(elapsed: _timerService.elapsed));
  }

  void _onEnd(EndWorkout event, Emitter<WorkoutState> emit) async {
    _timerService.stop();
    await _stopListeningToStats();
    await notifications.cancel(1);

    // TODO(byna): persist the stats

    add(UpdateStats(WorkoutStats(steps: 0, bpm: 0, calories: 0)));
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
    await notifications.cancel(1);
    return super.close();
  }
}
