import 'package:fit_track_pro/features/dashboard/presentation/widgets/custom_chart.dart';
import 'package:fit_track_pro/features/dashboard/presentation/widgets/morphing_fab.dart';
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
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CustomChart(
                            dataPoints: [
                              {
                                'steps': state.stats.steps,
                                'calories': state.stats.calories,
                                'bpm': state.stats.bpm,
                              }
                            ],
                          ),
                          const SizedBox(height: 20),
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
