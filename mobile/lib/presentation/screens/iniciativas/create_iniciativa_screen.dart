import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';
import 'package:igo_manager/presentation/widgets/audio_recorder_widget.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class CreateIniciativaScreen extends ConsumerStatefulWidget {
  const CreateIniciativaScreen({super.key});

  @override
  ConsumerState<CreateIniciativaScreen> createState() =>
      _CreateIniciativaScreenState();
}

class _CreateIniciativaScreenState
    extends ConsumerState<CreateIniciativaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;
  IniciativaModel? _editing;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is IniciativaModel) {
        setState(() {
          _editing = extra;
          _titleController.text = extra.title;
          _descriptionController.text = extra.description ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onPriorizar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión')),
      );
      setState(() => _isSaving = false);
      return;
    }
    final now = DateTime.now();
    if (_editing != null) {
      final updated = _editing!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        updatedAt: now,
      );
      await ref.read(iniciativasProvider.notifier).updateIniciativa(updated);
      if (!mounted) return;
      setState(() => _isSaving = false);
      context.pop();
    } else {
      final iniciativa = IniciativaModel(
        id: const Uuid().v4(),
        userId: user.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(iniciativasProvider.notifier).createIniciativa(iniciativa);
      if (!mounted) return;
      setState(() => _isSaving = false);
      final list = ref.read(iniciativasProvider).valueOrNull ?? [];
      final created = list.isNotEmpty ? list.first : iniciativa;
      context.push(AppRoutes.priorizacion.replaceAll(':id', created.id));
    }
  }

  Future<void> _onSaveDraft() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es obligatorio')),
      );
      return;
    }
    setState(() => _isSaving = true);
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión')),
      );
      setState(() => _isSaving = false);
      return;
    }
    final now = DateTime.now();
    if (_editing != null) {
      final updated = _editing!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        updatedAt: now,
      );
      await ref.read(iniciativasProvider.notifier).updateIniciativa(updated);
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Iniciativa actualizada'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else {
      final iniciativa = IniciativaModel(
        id: const Uuid().v4(),
        userId: user.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(iniciativasProvider.notifier).createIniciativa(iniciativa);
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Borrador guardado'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.iniciativaCreateTitle),
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
                TextFormField(
                  controller: _titleController,
                  maxLength: 160,
                  decoration: const InputDecoration(
                    labelText: AppStrings.iniciativaFormTitle,
                    hintText: '¿Qué iniciativa quieres priorizar?',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: AppStrings.iniciativaFormDescription,
                    hintText: 'Describe tu iniciativa en detalle...',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: S.h(context, 0.03)),
                AudioRecorderWidget(
                  onTranscriptionComplete: (text) {
                    if (_titleController.text.isEmpty) {
                      _titleController.text = text;
                    } else {
                      _descriptionController.text = text;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transcripción: "$text"')),
                    );
                  },
                ),
                SizedBox(height: S.h(context, 0.04)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _onPriorizar,
                    icon: const Icon(Icons.auto_graph),
                    label: Text(
                      'Priorizar',
                      style: TextStyle(
                          fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.015)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _onSaveDraft,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.of(context).textSecondary,
                      side: BorderSide(color: AppColors.of(context).border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(
                            AppStrings.iniciativaFormSave,
                            style: TextStyle(
                                fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
