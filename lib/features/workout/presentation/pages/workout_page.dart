import 'package:fit_track_pro/core/utils/formatter.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_track_pro/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_track_pro/features/workout/presentation/widgets/ring_painter.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _cardController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: Curves.easeOut,
      ),
    );

    _cardController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity != 0) {
      if (details.primaryVelocity! < 0) {
        // swipe left to skip
        context.read<WorkoutBloc>().add(SkipWorkout());
      } else {
        // swipe right to pause
        context.read<WorkoutBloc>().add(PauseWorkout());
      }
    }
  }

  String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _handleSwipe,
      child: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutPaused) {
            _pulseController.stop();
          } else if (state is WorkoutInProgress) {
            _pulseController.repeat(reverse: true);
          }
        },
        child: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            final seconds = state is WorkoutInProgress || state is WorkoutPaused
                ? (state as dynamic).elapsed
                : 0;

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatDuration(seconds),
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Hero(
                          tag: 'start-workout',
                          child: AnimatedRing(progress: (seconds % 60) / 60),
                        ),
                        ScaleTransition(
                          scale: Tween(begin: 1.0, end: 1.05).animate(
                            CurvedAnimation(
                              parent: _pulseController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Live Heart Rate',
                                style: TextStyle(fontSize: 18),
                              ),
                              BlocBuilder<DashboardCubit, DashboardState>(
                                builder: (context, dashboardState) {
                                  final bpm = dashboardState.stats.bpm;

                                  return Text(
                                    '$bpm BPM',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, dashboardState) {
                        return SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: WorkoutStatCard(
                                    icon: const WalkingMan(),
                                    label: 'Steps',
                                    value: numberFormat(
                                        dashboardState.stats.steps),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: WorkoutStatCard(
                                    icon: const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    label: 'Calories',
                                    value: numberFormat(
                                        dashboardState.stats.calories),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              bottomSheet: BottomSheet(
                onClosing: () {},
                builder: (_) => Container(
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     context.read<WorkoutBloc>().add(StartWorkout());
                      //   },
                      //   icon: const Icon(Icons.play_arrow),
                      //   label: const Text('Start'),
                      // ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (state is WorkoutInitial) {
                            context.read<WorkoutBloc>().add(StartWorkout());
                          } else if (state is WorkoutPaused) {
                            context
                                .read<WorkoutBloc>()
                                .add(ResumeWorkout(elapsed: state.elapsed));
                          } else {
                            context.read<WorkoutBloc>().add(PauseWorkout());
                          }
                        },
                        icon: Icon(
                          state is WorkoutInProgress
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        label: state is WorkoutInitial
                            ? const Text('Start')
                            : state is WorkoutInProgress
                                ? const Text('Pause')
                                : const Text('Resume'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<WorkoutBloc>().add(SkipWorkout());
                        },
                        icon: const Icon(Icons.skip_next),
                        label: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkoutStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget icon;

  const WorkoutStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalkingMan extends StatelessWidget {
  const WalkingMan({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/walking_man.gif',
      width: 40,
      height: 40,
    );
  }
}
