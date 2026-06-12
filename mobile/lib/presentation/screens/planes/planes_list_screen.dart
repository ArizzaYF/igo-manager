import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/data/models/plan_accion_model.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';
import 'package:igo_manager/presentation/providers/planes_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class PlanesListScreen extends ConsumerStatefulWidget {
  const PlanesListScreen({super.key});

  @override
  ConsumerState<PlanesListScreen> createState() => _PlanesListScreenState();
}

class _PlanesListScreenState extends ConsumerState<PlanesListScreen> {
  String _statusFilter = 'Todos';

  static const _filters = ['Todos', 'Pendientes', 'En Proceso', 'Terminados'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final user = ref.read(authProvider).valueOrNull;
    if (user != null) {
      ref.read(planesProvider.notifier).loadPlans(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planesAsync = ref.watch(planesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.planesTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.04), vertical: S.h(context, 0.015)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final selected = _statusFilter == filter;
                  return Padding(
                    padding: EdgeInsets.only(right: S.w(context, 0.02)),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _statusFilter = filter);
                      },
                      selectedColor: AppColors.of(context).primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.of(context).textPrimary,
                        fontSize: S.sp(context, 13),
                      ),
                      backgroundColor: AppColors.of(context).primaryShade,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: planesAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.of(context).primary),
              ),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style: TextStyle(color: AppColors.of(context).error)),
              ),
              data: (planes) {
                final iniciativas = ref.watch(iniciativasProvider).valueOrNull ?? [];
                final filtered = _filterPlanes(planes);
                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: S.w(context, 0.18),
                                  color: AppColors.of(context).textHint,
                                ),
                                SizedBox(height: S.h(context, 0.02)),
                                Text(
                                  AppStrings.planesEmpty,
                                  style: TextStyle(
                                    fontSize: S.sp(context, 15),
                                    color: AppColors.of(context).textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: EdgeInsets.all(S.w(context, 0.04)),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final plan = filtered[index];
                      final iniTitle = iniciativas
                          .where((i) => i.id == plan.initiativeId)
                          .firstOrNull
                          ?.title ?? plan.initiativeId;
                      return _PlanCard(
                        iniciativaTitle: iniTitle,
                        status: _statusLabel(plan.status),
                        deadline:
                            '${plan.deadlineAt?.day}/${plan.deadlineAt?.month}/${plan.deadlineAt?.year}',
                        progress: plan.progressPercent / 100.0,
                        onTap: () =>
                            context.push('${AppRoutes.planes}/${plan.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PlanModel> _filterPlanes(List<PlanModel> planes) {
    switch (_statusFilter) {
      case 'Pendientes':
        return planes.where((p) => p.status == 'pendiente').toList();
      case 'En Proceso':
        return planes.where((p) => p.status == 'en_proceso').toList();
      case 'Terminados':
        return planes.where((p) => p.status == 'terminado').toList();
      default:
        return planes;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pendiente':
        return 'Pendientes';
      case 'en_proceso':
        return 'En Proceso';
      case 'terminado':
        return 'Terminados';
      default:
        return status;
    }
  }
}

class _PlanCard extends StatelessWidget {
  final String iniciativaTitle;
  final String status;
  final String deadline;
  final double progress;
  final VoidCallback onTap;

  const _PlanCard({
    required this.iniciativaTitle,
    required this.status,
    required this.deadline,
    required this.progress,
    required this.onTap,
  });

  Color _statusColor(BuildContext context, String s) {
    switch (s) {
      case 'Pendientes':
        return AppColors.of(context).warning;
      case 'En Proceso':
        return AppColors.of(context).info;
      case 'Terminados':
        return AppColors.of(context).success;
      default:
        return AppColors.of(context).textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: S.h(context, 0.015)),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(S.w(context, 0.04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      iniciativaTitle,
                      style: TextStyle(
                        fontSize: S.sp(context, 16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.of(context).textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: S.w(context, 0.02), vertical: S.h(context, 0.005)),
                    decoration: BoxDecoration(
                      color: _statusColor(context, status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: S.sp(context, 11),
                        fontWeight: FontWeight.w600,
                        color: _statusColor(context, status),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: S.h(context, 0.015)),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 14, color: AppColors.of(context).textSecondary),
                  SizedBox(width: S.w(context, 0.015)),
                  Text(
                    'Límite: $deadline',
                    style: TextStyle(
                      fontSize: S.sp(context, 12),
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: S.h(context, 0.013)),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.of(context).border,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.of(context).success),
                  minHeight: 8,
                ),
              ),
              SizedBox(height: S.h(context, 0.005)),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: S.sp(context, 11),
                    color: AppColors.of(context).textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
