import 'package:fit_track_pro/core/di/injector.dart';
import 'package:fit_track_pro/core/services/notification_service.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fit_track_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fit_track_pro/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_track_pro/features/workout/presentation/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  try {
    NotificationService.init();
  } catch (e) {
    // print(e);
  }

  runApp(const FitTrackApp());
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DashboardCubit>()),
        BlocProvider(create: (_) => sl<WorkoutBloc>()),
      ],
      child: MaterialApp(
        title: 'FitTrack Pro',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (_) => const DashboardPage(),
          '/workout': (_) => const WorkoutPage(),
        },
      ),
    );
  }
}
