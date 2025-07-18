import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fit_track_pro/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_track_pro/core/services/notification_service.dart';
import 'package:fit_track_pro/features/workout/domain/repository/i_workout_repository.dart';
import 'package:fit_track_pro/features/workout/data/services/workout_timer_service.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'dart:async';

class FakeWorkoutSession extends Fake implements WorkoutSession {}

class MockWorkoutRepository extends Mock implements IWorkoutRepository {}

class MockWorkoutTimerService extends Mock implements WorkoutTimerService {
  void Function(int)? _tickCallback;
  int _elapsed = 0;

  @override
  int get elapsed => _elapsed;

  @override
  void start(void Function(int) onTick) {
    _tickCallback = onTick;
    _tickCallback!(0);
  }

  @override
  void pause() {}

  @override
  void resume() {
    _tickCallback?.call(_elapsed);
  }

  @override
  void stop() {}

  @override
  void dispose() {}

  void simulateTick(int seconds) {
    _elapsed = seconds;
    _tickCallback?.call(seconds);
  }
}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeWorkoutSession());
  });

  late WorkoutBloc bloc;
  late MockWorkoutRepository workoutRepository;
  late MockWorkoutTimerService timerService;
  late MockNotificationService notificationService;

  setUp(() {
    workoutRepository = MockWorkoutRepository();
    timerService = MockWorkoutTimerService();
    notificationService = MockNotificationService();

    when(() => workoutRepository.resetStatsStream()).thenAnswer((_) async {});
    when(() => workoutRepository.saveSession(any())).thenAnswer((_) async {});
    when(() => workoutRepository.getWorkoutStatsStream())
        .thenAnswer((_) => const Stream<WorkoutStats>.empty());

    when(
      () => notificationService.showWorkoutProgress(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async {});
    when(() => notificationService.cancel(any())).thenAnswer((_) async {});

    bloc = WorkoutBloc(workoutRepository, timerService, notificationService);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('emits [WorkoutInProgress, WorkoutInProgress, WorkoutCompleted]',
      () async {
    final expected = [
      isA<WorkoutInProgress>(),
      isA<WorkoutInProgress>(),
      isA<WorkoutCompleted>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(StartWorkout());
    await Future.delayed(const Duration(milliseconds: 100));

    timerService.simulateTick(2);
    await Future.delayed(const Duration(milliseconds: 100));

    bloc.add(EndWorkout());
  });
}
