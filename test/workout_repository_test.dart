import 'package:fit_track_pro/features/workout/data/repository/workout_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fit_track_pro/features/dashboard/domain/model/workout_stats.dart';
import 'package:fit_track_pro/features/workout/domain/model/workout_session.dart';

class FakeWorkoutSession extends Fake implements WorkoutSession {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WorkoutRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeWorkoutSession());
  });

  setUp(() {
    repository = WorkoutRepository();
  });

  group('WorkoutRepository', () {
    test('saveSession should persist workout sessions', () async {
      SharedPreferences.setMockInitialValues({});
      final session = WorkoutSession(
        date: DateTime.now(),
        duration: 30,
        stats: WorkoutStats(steps: 1000, bpm: 78, calories: 100),
      );

      await repository.saveSession(session);
      final sessions = await repository.getSessions();

      expect(sessions.length, 1);
    });

    test('getSessions returns empty if no data exists', () async {
      SharedPreferences.setMockInitialValues({});
      final sessions = await repository.getSessions();

      expect(sessions, isEmpty);
    });

    test('resetStatsStream invokes native reset method', () async {
      const MethodChannel channel = MethodChannel('workout_channel');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'resetStats') {
          return null;
        }
        throw PlatformException(code: 'Unimplemented');
      });

      await repository.resetStatsStream();
    });
  });
}
