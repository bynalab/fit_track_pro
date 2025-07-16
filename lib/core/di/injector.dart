import 'package:fit_track_pro/core/services/notification_service.dart';
import 'package:fit_track_pro/features/workout/data/repository/workout_repository.dart';
import 'package:fit_track_pro/features/workout/data/services/workout_timer_service.dart';
import 'package:get_it/get_it.dart';
import 'package:fit_track_pro/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton<WorkoutRepository>(() => WorkoutRepository());

  sl.registerLazySingleton(() => DashboardCubit(sl<WorkoutRepository>()));
  sl.registerLazySingleton(
    () => WorkoutBloc(
      sl<WorkoutRepository>(),
      WorkoutTimerService(),
      NotificationService(),
    ),
  );
}
