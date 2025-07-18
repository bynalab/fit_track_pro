import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';
import 'package:fit_track_pro/features/workout/domain/repository/i_workout_repository.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class MockWorkoutRepository extends Mock implements IWorkoutRepository {}

class FakeWorkoutSession extends Fake implements WorkoutSession {}

void main() {
  late MockWorkoutRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeWorkoutSession());
  });

  setUp(() {
    mockRepository = MockWorkoutRepository();
  });

  test('loads dashboard data and emits correct stats and sessions', () async {
    final now = DateTime.now();

    final mockSessions = [
      WorkoutSession(
        date: now,
        stats: WorkoutStats(steps: 1000, calories: 300, bpm: 80),
        duration: 600,
      ),
      WorkoutSession(
        date: now.subtract(const Duration(days: 1)),
        stats: WorkoutStats(steps: 500, calories: 200, bpm: 75),
        duration: 400,
      ),
      WorkoutSession(
        date: now,
        stats: WorkoutStats(steps: 1500, calories: 500, bpm: 85),
        duration: 900,
      ),
    ];

    when(() => mockRepository.getSessions())
        .thenAnswer((_) async => mockSessions);

    final cubit = DashboardCubit(mockRepository);

    await expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<DashboardState>((state) => state.isLoading == true),
        predicate<DashboardState>((state) {
          final stats = state.stats;
          return state.isLoading == false &&
              state.sessions.length == 3 &&
              stats.steps == 2500 &&
              stats.calories == 800 &&
              stats.bpm == 165;
        }),
      ]),
    );
  });
}
