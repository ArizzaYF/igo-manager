import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/data/models/plan_accion_model.dart';
import 'package:igo_manager/data/repositories/plan_repository.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';
import 'package:igo_manager/presentation/providers/planes_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const PlanDetailScreen({required this.id, super.key});

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  final _planRepo = PlanRepository();
  PlanModel? _plan;
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String? _iniciativaTitle;

  static const _statuses = ['pendiente', 'en_proceso', 'terminado', 'abortado'];
  static const _statusLabels = ['Pendiente', 'En progreso', 'Completado', 'Cancelado'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    final planResult = await _planRepo.getPlanById(widget.id);
    if (!mounted) return;

    planResult.fold(
      (_) => setState(() => _isLoading = false),
      (plan) async {
        final taskResult = await _planRepo.getTasks(plan.id);
        if (!mounted) return;

        taskResult.fold(
          (_) => setState(() => _isLoading = false),
          (tasks) {
            final iniciativas = ref.read(iniciativasProvider).valueOrNull ?? [];
            final iniciativa = iniciativas.where((i) => i.id == plan.initiativeId).firstOrNull;
            setState(() {
              _plan = plan;
              _tasks = tasks;
              _iniciativaTitle = iniciativa?.title ?? plan.initiativeId;
              _isLoading = false;
            });
          },
        );
      },
    );
  }

  void _toggleTask(TaskModel task) async {
    final newStatus = task.status == 'terminado' ? 'pendiente' : 'terminado';
    final result = await _planRepo.updateTaskStatus(task.id, newStatus);
    result.fold(
      (_) {},
      (_) async {
        final updated = task.copyWith(status: newStatus);
        final newTasks =
            _tasks.map((t) => t.id == task.id ? updated : t).toList();
        final done = newTasks.where((t) => t.status == 'terminado').length;
        final progress = newTasks.isEmpty ? 0 : (done / newTasks.length * 100).round();
        final newStatusPlan = progress >= 100 ? 'terminado' : _plan!.status;
        setState(() {
          _tasks = newTasks;
          _plan = _plan!.copyWith(
            progressPercent: progress,
            status: newStatusPlan,
          );
        });
        await _planRepo.updatePlanProgress(widget.id, progress, newStatusPlan);
        ref.read(planesProvider.notifier).updatePlanLocally(_plan!);
      },
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (ctx) {
        final titleCtrl = TextEditingController();
        final respCtrl = TextEditingController();
        return AlertDialog(
          title: const Text(AppStrings.taskCreate),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  hintText: AppStrings.taskTitle,
                ),
                autofocus: true,
              ),
              SizedBox(height: S.h(context, 0.015)),
              TextField(
                controller: respCtrl,
                decoration: const InputDecoration(
                  hintText: AppStrings.taskResponsible,
                  prefixIcon: Icon(Icons.person_outline, size: 18),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                final now = DateTime.now();
                final result = await _planRepo.createTask(TaskModel(
                  id: '',
                  planId: widget.id,
                  title: titleCtrl.text.trim(),
                  responsible: respCtrl.text.trim(),
                  status: 'pendiente',
                  sortOrder: _tasks.length + 1,
                  createdAt: now,
                  updatedAt: now,
                ));
                if (mounted && ctx.mounted) Navigator.pop(ctx);
                result.fold(
                  (_) {},
                  (task) async {
                    setState(() {
                      _tasks = [..._tasks, task];
                      final done = _tasks.where((t) => t.status == 'terminado').length;
                      final progress = _tasks.isEmpty ? 0 : (done / _tasks.length * 100).round();
                      _plan = _plan!.copyWith(progressPercent: progress);
                    });
                    await _planRepo.updatePlanProgress(widget.id, _plan!.progressPercent, _plan!.status);
                    ref.read(planesProvider.notifier).updatePlanLocally(_plan!);
                  },
                );
              },
              child: const Text(AppStrings.save),
            ),
          ],
        );
      },
    );
  }

  String get _countdown {
    final deadline = _plan?.deadlineAt;
    if (deadline == null) return 'Sin fecha';
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return 'Vencido';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    return '$days días $hours h';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.of(context).primary),
        ),
      );
    }

    final plan = _plan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan de Acción'),
        elevation: 0,
      ),
      body: plan == null
          ? const Center(child: Text('Plan no encontrado'))
          : SingleChildScrollView(
              padding: EdgeInsets.all(S.w(context, 0.06)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _iniciativaTitle ?? 'Nombre de la iniciativa',
                    style: TextStyle(
                      fontSize: S.sp(context, 20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(S.w(context, 0.05)),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryShade,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (plan.progressPercent / 100.0).clamp(0.0, 1.0),
                              minHeight: 16,
                              backgroundColor: AppColors.of(context).border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.of(context).success,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: S.h(context, 0.015)),
                        Text(
                          '${plan.progressPercent}% Completado',
                          style: TextStyle(
                            fontSize: S.sp(context, 14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.of(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 18, color: AppColors.of(context).primary),
                      SizedBox(width: S.w(context, 0.02)),
                      Text(
                        'Tiempo restante: ',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                      Text(
                        _countdown,
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          fontWeight: FontWeight.bold,
                          color: AppColors.of(context).primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.02)),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18, color: AppColors.of(context).textSecondary),
                      SizedBox(width: S.w(context, 0.02)),
                      Text(
                        '${AppStrings.planesDeadline}: ',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                      Text(
                        plan.deadlineAt != null
                            ? '${plan.deadlineAt!.day}/${plan.deadlineAt!.month}/${plan.deadlineAt!.year}'
                            : 'Sin fecha',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.of(context).textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.02)),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          size: 18, color: AppColors.of(context).textSecondary),
                      SizedBox(width: S.w(context, 0.02)),
                      Text(
                        '${AppStrings.planesBudget}: ',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                      Text(
                        plan.estimatedBudget != null
                            ? '\$${plan.estimatedBudget!.toStringAsFixed(2)}'
                            : 'No especificado',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.of(context).textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.02)),
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 18, color: AppColors.of(context).textSecondary),
                      SizedBox(width: S.w(context, 0.02)),
                      Text(
                        '${AppStrings.planesAllies}: ',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          plan.allies.isNotEmpty
                              ? plan.allies.join(', ')
                              : 'Sin aliados',
                          style: TextStyle(
                            fontSize: S.sp(context, 14),
                            color: AppColors.of(context).textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estado',
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                      DropdownButton<String>(
                        value: plan.status,
                        onChanged: (v) async {
                          if (v == null) return;
                          await ref
                              .read(planesProvider.notifier)
                              .updateStatus(widget.id, v);
                          if (mounted) _load();
                        },
                        items: List.generate(_statuses.length, (i) {
                          return DropdownMenuItem(
                            value: _statuses[i],
                            child: Text(_statusLabels[i]),
                          );
                        }),
                        underline: const SizedBox(),
                        style: TextStyle(
                          fontSize: S.sp(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.of(context).primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.03)),
                  const Divider(),
                  SizedBox(height: S.h(context, 0.02)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.planesTasks,
                        style: TextStyle(
                          fontSize: S.sp(context, 16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.of(context).textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addTask,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(AppStrings.taskCreate),
                      ),
                    ],
                  ),
                  ..._tasks.map((task) => CheckboxListTile(
                      value: task.status == 'terminado',
                      onChanged: (_) => _toggleTask(task),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: S.sp(context, 14),
                              decoration: task.status == 'terminado'
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.status == 'terminado'
                                  ? AppColors.of(context).textHint
                                  : AppColors.of(context).textPrimary,
                            ),
                          ),
                          if (task.responsible != null && task.responsible!.isNotEmpty)
                            Text(
                              task.responsible!,
                              style: TextStyle(
                                fontSize: S.sp(context, 12),
                                color: AppColors.of(context).textSecondary,
                              ),
                            ),
                        ],
                      ),
                      activeColor: AppColors.of(context).primary,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                  )),
                  SizedBox(height: S.h(context, 0.03)),
                ],
              ),
            ),
    );
  }
}
