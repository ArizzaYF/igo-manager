import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/data/models/plan_accion_model.dart';
import 'package:igo_manager/data/repositories/plan_repository.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';
import 'package:igo_manager/presentation/providers/planes_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class CreatePlanScreen extends ConsumerStatefulWidget {
  final String iniciativaId;
  const CreatePlanScreen({required this.iniciativaId, super.key});

  @override
  ConsumerState<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends ConsumerState<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _responsibleController = TextEditingController();
  DateTime? _deadline;
  final List<String> _allies = [];
  final _allyController = TextEditingController();
  final List<_TaskEntry> _tasks = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _responsibleController.dispose();
    _allyController.dispose();
    for (final t in _tasks) {
      t.titleController.dispose();
      t.responsibleController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.of(context).primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _addAlly() {
    final text = _allyController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _allies.add(text);
      _allyController.clear();
    });
  }

  void _addTask() {
    setState(() {
      _tasks.add(_TaskEntry(
        titleController: TextEditingController(),
        responsibleController: TextEditingController(),
      ));
    });
  }

  void _removeTask(int index) {
    final task = _tasks[index];
    task.titleController.dispose();
    task.responsibleController.dispose();
    setState(() => _tasks.removeAt(index));
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha límite')),
      );
      return;
    }

    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final createdPlan = await ref.read(planesProvider.notifier).createPlan(
          PlanModel(
            id: '',
            initiativeId: widget.iniciativaId,
            userId: user.id,
            deadlineAt: _deadline,
            estimatedBudget: double.tryParse(_budgetController.text),
            allies: List.from(_allies),
            responsible: _responsibleController.text.trim(),
            status: 'pendiente',
            progressPercent: 0,
            createdAt: now,
            updatedAt: now,
          ),
        );

    if (createdPlan != null && _tasks.isNotEmpty) {
      final planRepo = PlanRepository();
      for (var i = 0; i < _tasks.length; i++) {
        final t = _tasks[i];
        await planRepo.createTask(TaskModel(
          id: '',
          planId: createdPlan.id,
          title: t.titleController.text.trim(),
          responsible: t.responsibleController.text.trim(),
          status: 'pendiente',
          sortOrder: i + 1,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (createdPlan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Plan de acción creado exitosamente'),
          backgroundColor: AppColors.of(context).success,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al crear el plan de acción'),
          backgroundColor: AppColors.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iniciativasAsync = ref.watch(iniciativasProvider);
    final iniciativa = iniciativasAsync.valueOrNull
        ?.where((i) => i.id == widget.iniciativaId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.planesCreate),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(S.w(context, 0.06)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Iniciativa asociada',
                  style: TextStyle(
                    fontSize: S.sp(context, 13),
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
                SizedBox(height: S.h(context, 0.005)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(S.w(context, 0.035)),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryShade.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    iniciativa?.title ?? 'Cargando...',
                    style: TextStyle(
                      fontSize: S.sp(context, 15),
                      fontWeight: FontWeight.w500,
                      color: AppColors.of(context).primary,
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.025)),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppStrings.planesDeadline,
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        hintText: _deadline != null
                            ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                            : 'Seleccionar fecha',
                      ),
                      controller: TextEditingController(
                        text: _deadline != null
                            ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                            : '',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.planesBudget,
                    prefixIcon: Icon(Icons.attach_money),
                    hintText: '\$0.00',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _responsibleController,
                  decoration: const InputDecoration(
                    labelText: '${AppStrings.planesResponsible} principal',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.025)),
                Text(
                  AppStrings.planesAllies,
                  style: TextStyle(
                    fontSize: S.sp(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: S.h(context, 0.01)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _allyController,
                        decoration: const InputDecoration(
                          hintText: 'Nombre del aliado',
                        ),
                      ),
                    ),
                    SizedBox(width: S.w(context, 0.02)),
                    IconButton(
                      onPressed: _addAlly,
                      icon: const Icon(Icons.add_circle),
                      color: AppColors.of(context).primary,
                    ),
                  ],
                ),
                if (_allies.isNotEmpty) ...[
                  SizedBox(height: S.h(context, 0.01)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _allies
                        .map(
                          (ally) => Chip(
                            label: Text(ally, style: TextStyle(fontSize: S.sp(context, 13))),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() => _allies.remove(ally));
                            },
                            backgroundColor: AppColors.of(context).primaryShade,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                ],
                SizedBox(height: S.h(context, 0.03)),
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
                if (_tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(S.w(context, 0.05)),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryShade,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'No hay tareas agregadas aún',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.of(context).textSecondary,
                        fontSize: S.sp(context, 13),
                      ),
                    ),
                  )
                else
                  ..._tasks.asMap().entries.map((entry) {
                    final i = entry.key;
                    final task = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(S.w(context, 0.03)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: task.titleController,
                                    decoration: const InputDecoration(
                                      hintText: AppStrings.taskTitle,
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      size: 20, color: AppColors.of(context).error),
                                  onPressed: () => _removeTask(i),
                                ),
                              ],
                            ),
                            TextField(
                              controller: task.responsibleController,
                              decoration: const InputDecoration(
                                hintText: AppStrings.taskResponsible,
                                isDense: true,
                                prefixIcon:
                                    Icon(Icons.person_outline, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                SizedBox(height: S.h(context, 0.04)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onCreate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.of(context).primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Crear Plan',
                            style: TextStyle(
                                fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.03)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskEntry {
  final TextEditingController titleController;
  final TextEditingController responsibleController;

  _TaskEntry({
    required this.titleController,
    required this.responsibleController,
  });
}
