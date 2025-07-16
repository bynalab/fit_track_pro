import 'package:fit_track_pro/features/dashboard/data/workout_repository.dart';
import 'package:fit_track_pro/features/workout/data/services/workout_timer_service.dart';
import 'package:get_it/get_it.dart';
import 'package:fit_track_pro/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton(() => DashboardCubit(WorkoutRepository()));
  sl.registerLazySingleton(() => WorkoutBloc(WorkoutTimerService()));
}
