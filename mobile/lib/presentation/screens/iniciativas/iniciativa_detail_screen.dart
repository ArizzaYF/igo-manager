import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class IniciativaDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const IniciativaDetailScreen({required this.id, super.key});

  @override
  ConsumerState<IniciativaDetailScreen> createState() =>
      _IniciativaDetailScreenState();
}

class _IniciativaDetailScreenState
    extends ConsumerState<IniciativaDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final iniciativasAsync = ref.watch(iniciativasProvider);
    final iniciativa = iniciativasAsync.valueOrNull?.where(
      (i) => i.id == widget.id,
    ).firstOrNull;

    if (iniciativasAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (iniciativa == null) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: const Center(
          child: Text('Iniciativa no encontrada'),
        ),
      );
    }

    final dateFormat = DateFormat('dd/MM/yyyy');
    final quadrant = iniciativa.quadrant ?? iniciativa.computedQuadrant;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.iniciativaDetailTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(S.w(context, 0.06)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: S.w(context, 0.03), vertical: S.h(context, 0.008)),
              decoration: BoxDecoration(
                color: IgoCalculator.colorFromString(quadrant).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                IgoCalculator.dbKeyToLabel(quadrant),
                style: TextStyle(
                  fontSize: S.sp(context, 13),
                  fontWeight: FontWeight.w600,
                  color: IgoCalculator.colorFromString(quadrant),
                ),
              ),
            ),
            SizedBox(height: S.h(context, 0.015)),
            Text(
              iniciativa.title,
              style: TextStyle(
                fontSize: S.sp(context, 22),
                fontWeight: FontWeight.bold,
                color: AppColors.of(context).textPrimary,
              ),
            ),
            if (iniciativa.description != null) ...[
              SizedBox(height: S.h(context, 0.015)),
              Text(
                iniciativa.description!,
                style: TextStyle(
                  fontSize: S.sp(context, 14),
                color: AppColors.of(context).textSecondary,
                height: 1.6,
                ),
              ),
            ],
            SizedBox(height: S.h(context, 0.03)),
            const Divider(),
            SizedBox(height: S.h(context, 0.02)),
            Text(
              'Clasificación IGO',
              style: TextStyle(
                fontSize: S.sp(context, 16),
                fontWeight: FontWeight.w600,
                color: AppColors.of(context).textPrimary,
              ),
            ),
            SizedBox(height: S.h(context, 0.02)),
            _buildInfoRow('Importancia', (iniciativa.importance ~/ 2).toString()),
            SizedBox(height: S.h(context, 0.01)),
            _buildInfoRow('Gobernabilidad', (iniciativa.governability ~/ 2).toString()),
            SizedBox(height: S.h(context, 0.015)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(
                  AppRoutes.priorizacion.replaceAll(':id', iniciativa.id),
                ),
                icon: const Icon(Icons.tune_outlined, size: 18),
                label: const Text('Recalificar priorización'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentDark,
                  side: const BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: S.h(context, 0.03)),
            const Divider(),
            SizedBox(height: S.h(context, 0.02)),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: AppColors.of(context).textSecondary),
                SizedBox(width: S.w(context, 0.02)),
                Text(
                  'Creada: ${dateFormat.format(iniciativa.createdAt)}',
                  style: TextStyle(
                    fontSize: S.sp(context, 13),
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: S.h(context, 0.03)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(
                  AppRoutes.planesCreate.replaceAll(':iniciativaId', iniciativa.id),
                ),
                icon: const Icon(Icons.assignment_outlined),
                label: const Text('Crear Plan de Acción'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: S.h(context, 0.015)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.iniciativasCreate,
                      extra: iniciativa,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(AppStrings.edit),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: S.w(context, 0.03)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Archivar iniciativa'),
                          content: const Text(
                              '¿Estás seguro de archivar esta iniciativa?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(iniciativasProvider.notifier)
                                    .archiveIniciativa(widget.id);
                                Navigator.pop(ctx);
                                context.pop();
                              },
                              child: const Text('Archivar',
                                  style: TextStyle(color: AppColors.warning)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.archive_outlined, size: 18),
                    label: const Text('Archivar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      side: const BorderSide(color: AppColors.warning),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: S.sp(context, 14),
            color: AppColors.of(context).textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: S.sp(context, 14),
            fontWeight: FontWeight.bold,
            color: AppColors.of(context).textPrimary,
          ),
        ),
      ],
    );
  }

}
