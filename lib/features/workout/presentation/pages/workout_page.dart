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
    if (details.primaryVelocity != null) {
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
        child: Scaffold(
          body: BlocBuilder<WorkoutBloc, WorkoutState>(
            builder: (context, state) {
              final seconds =
                  state is WorkoutInProgress || state is WorkoutPaused
                      ? (state as dynamic).elapsed
                      : 0;

              return Center(
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
                        Positioned(
                          bottom: 80,
                          child: ScaleTransition(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, dashboardState) {
                        return SlideTransition(
                          position: _slideAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatCard(
                                icon: const WalkingMan(),
                                label: 'Steps',
                                value: numberFormat(dashboardState.stats.steps),
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                icon: const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                label: 'Calories',
                                value:
                                    numberFormat(dashboardState.stats.calories),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          bottomSheet: BottomSheet(
            onClosing: () {},
            builder: (_) => Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<WorkoutBloc>().add(PauseWorkout());
                    },
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<WorkoutBloc>()
                          .add(const ResumeWorkout(elapsed: 60));
                    },
                    icon: const Icon(Icons.start),
                    label: const Text('Resume'),
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
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required Widget icon,
    required String label,
    required String value,
  }) {
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
