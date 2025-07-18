import 'package:fit_track_pro/features/dashboard/presentation/widgets/custom_chart.dart';
import 'package:fit_track_pro/features/dashboard/presentation/widgets/morphing_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_track_pro/features/dashboard/presentation/widgets/staggered_animation_list.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fit_track_pro/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:fit_track_pro/features/dashboard/presentation/widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardCubit>().refresh();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 300,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          final delta = constraints.maxHeight - kToolbarHeight;
                          final t =
                              (delta / (250 - kToolbarHeight)).clamp(0.0, 1.0);
                          final isExpanded = t > 0.5;

                          return Container(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: StaggeredAnimationList(
                                  direction: isExpanded
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  children: [
                                    DashboardCard(
                                      title: 'Steps',
                                      value: state.stats.steps,
                                      unit: 'Steps',
                                      icon: Icons.directions_walk,
                                      color: Colors.tealAccent.shade100,
                                    ),
                                    DashboardCard(
                                      title: 'Calories',
                                      value: state.stats.calories,
                                      unit: 'Cal',
                                      icon: Icons.local_fire_department,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    Hero(
                                      tag: 'bpm',
                                      child: DashboardCard(
                                        title: 'Heart Rate',
                                        value: state.stats.bpm,
                                        unit: 'BPM',
                                        icon: Icons.favorite,
                                        color: Colors.pinkAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: CustomChart(sessions: state.sessions),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: const MorphingFABMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
