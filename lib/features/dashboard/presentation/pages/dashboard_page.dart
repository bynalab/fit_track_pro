import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_track_pro/features/dashboard/animated.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:fit_track_pro/features/dashboard/presentation/widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                // final cubit = context.read<DashboardCubit>();
                // final old = cubit.state.stats;
                // cubit.updateStats(old.copyWith(
                //   steps: old.steps + 100,
                //   calories: old.calories + 10,
                //   bpm: old.bpm + 1,
                // ));

                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          // CustomChart(
                          //   dataPoints: [
                          //     {
                          //       'steps': state.stats.steps,
                          //       'calories': state.stats.calories,
                          //       'bpm': state.stats.bpm,
                          //     }
                          //   ],
                          // )
                          AnimatedStatsList(
                        children: [
                          DashboardCard(
                            title: 'Steps',
                            value: state.stats.steps,
                            unit: 'steps',
                            icon: Icons.directions_walk,
                            color: Colors.green,
                          ),
                          DashboardCard(
                            title: 'Calories',
                            value: state.stats.calories,
                            unit: 'cal',
                            icon: Icons.local_fire_department,
                            color: Colors.yellow,
                          ),
                          DashboardCard(
                            title: 'Heart Rate',
                            value: state.stats.bpm,
                            unit: 'bpm',
                            icon: Icons.heart_broken,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: const Hero(
        tag: 'start-workout',
        child: MorphingFAB(),
      ),
    );
  }
}

class MorphingFAB extends StatefulWidget {
  const MorphingFAB({super.key});

  @override
  State<MorphingFAB> createState() => _MorphingFABState();
}

class _MorphingFABState extends State<MorphingFAB> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isExpanded = !isExpanded);
        Navigator.pushNamed(context, '/workout');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(isExpanded ? 16 : 50),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isExpanded
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stop),
                    SizedBox(width: 8),
                    Text('Stop')
                  ],
                )
              : const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
