// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:fit_track_pro/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}


// test/dashboard_cubit_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fittrack_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';

// void main() {
//   group('DashboardCubit', () {
//     test('updates stats correctly', () {
//       final cubit = DashboardCubit();
//       final initial = cubit.state.stats;

//       final updated = initial.copyWith(steps: 100, calories: 10, bpm: 80);
//       cubit.updateStats(updated);

//       expect(cubit.state.stats.steps, 100);
//       expect(cubit.state.stats.calories, 10);
//       expect(cubit.state.stats.bpm, 80);
//     });
//   });
// }

// // test/workout_bloc_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fittrack_pro/features/workout/presentation/bloc/workout_bloc.dart';

// void main() {
//   group('WorkoutBloc', () {
//     test('starts and ends workout', () async {
//       final bloc = WorkoutBloc();
//       bloc.add(StartWorkout());

//       await Future.delayed(const Duration(seconds: 2));
//       bloc.add(EndWorkout());

//       expectLater(bloc.stream, emitsInOrder([
//         isA<WorkoutInProgress>(),
//         isA<WorkoutInProgress>(),
//         isA<WorkoutCompleted>(),
//       ]));
//     });
//   });
// }


// // test/animation_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:fittrack_pro/animation/animated_stats_list.dart';

// void main() {
//   testWidgets('AnimatedStatsList animates all children', (tester) async {
//     await tester.pumpWidget(MaterialApp(
//       home: AnimatedStatsList(
//         children: [
//           Text('Steps'),
//           Text('Calories'),
//           Text('BPM'),
//         ],
//       ),
//     ));

//     await tester.pump(const Duration(milliseconds: 1500));
//     expect(find.text('Steps'), findsOneWidget);
//     expect(find.text('Calories'), findsOneWidget);
//     expect(find.text('BPM'), findsOneWidget);
//   });
// }
