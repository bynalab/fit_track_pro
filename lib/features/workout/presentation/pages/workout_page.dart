import 'package:fit_track_pro/core/utils/formatter.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fit_track_pro/features/workout/presentation/widgets/custom_button.dart';
import 'package:fit_track_pro/features/workout/presentation/widgets/walking_man.dart';
import 'package:fit_track_pro/features/workout/presentation/widgets/workout_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void triggerHapticFeeback() {
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _handleSwipe,
      child: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutCompleted) {
            context.read<DashboardCubit>().refresh();
          }

          if (state is WorkoutInProgress) {
            if (!_pulseController.isAnimating) {
              _pulseController.repeat(reverse: true);
            }
          } else {
            _pulseController.stop();
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
                          tag: 'bpm',
                          child: AnimatedRing(
                            progress: (seconds % 60) / 60,
                            controller: _pulseController,
                          ),
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
                              Text(
                                '${state.stats?.bpm ?? 0} BPM',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: WorkoutStatCard(
                                icon: WalkingMan(
                                  isAnimating: state is WorkoutInProgress,
                                ),
                                label: 'Steps',
                                value: numberFormat(state.stats?.steps),
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
                                value: numberFormat(state.stats?.calories),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: BottomSheet(
                enableDrag: false,
                onClosing: () {},
                builder: (_) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 20,
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              triggerHapticFeeback();

                              if (state is WorkoutInitial ||
                                  state is WorkoutCompleted) {
                                context.read<WorkoutBloc>().add(StartWorkout());
                              } else if (state is WorkoutPaused) {
                                context
                                    .read<WorkoutBloc>()
                                    .add(ResumeWorkout(elapsed: state.elapsed));
                              } else {
                                context.read<WorkoutBloc>().add(PauseWorkout());
                              }
                            },
                            label: switch (state) {
                              WorkoutInitial() || WorkoutCompleted() => 'Start',
                              WorkoutInProgress() => 'Pause',
                              _ => 'Resume'
                            },
                            icon: state is WorkoutInProgress
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        if (state is! WorkoutInitial &&
                            state is! WorkoutCompleted)
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                triggerHapticFeeback();
                                context.read<WorkoutBloc>().add(EndWorkout());
                              },
                              icon: Icons.stop,
                              label: 'End',
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
