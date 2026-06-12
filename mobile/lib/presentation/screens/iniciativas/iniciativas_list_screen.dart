import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class IniciativasListScreen extends ConsumerStatefulWidget {
  const IniciativasListScreen({super.key});

  @override
  ConsumerState<IniciativasListScreen> createState() =>
      _IniciativasListScreenState();
}

class _IniciativasListScreenState
    extends ConsumerState<IniciativasListScreen> {
  String _filter = 'Activas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIniciativas();
    });
  }

  Future<void> _loadIniciativas() async {
    final user = ref.read(authProvider).valueOrNull;
    if (user != null) {
      ref.read(iniciativasProvider.notifier).loadInitiatives(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iniciativasAsync = ref.watch(iniciativasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.iniciativasTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.perfil),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.04), vertical: S.h(context, 0.01)),
            child: Row(
              children: [
                _filterChip('Activas', context),
                SizedBox(width: S.w(context, 0.02)),
                _filterChip('Archivadas', context),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadIniciativas,
              child: iniciativasAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, stack) => ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: S.w(context, 0.18),
                              color: AppColors.error,
                            ),
                            SizedBox(height: S.h(context, 0.02)),
                            Text(
                              'Error al cargar: $error',
                              textAlign: TextAlign.center,
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
                data: (iniciativas) {
                  final filtered = iniciativas.where((i) {
                    if (_filter == 'Activas') return i.status == 'activa';
                    if (_filter == 'Archivadas') return i.status == 'archivada';
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _filter == 'Archivadas'
                                      ? Icons.archive_outlined
                                      : Icons.lightbulb_outline_rounded,
                                  size: S.w(context, 0.18),
                                  color: AppColors.of(context).textHint,
                                ),
                                SizedBox(height: S.h(context, 0.02)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.08)),
                                  child: Text(
                                    _filter == 'Archivadas'
                                        ? 'No hay iniciativas archivadas'
                                        : AppStrings.iniciativasEmpty,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: S.sp(context, 15),
                                      color: AppColors.of(context).textSecondary,
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(S.w(context, 0.04)),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final iniciativa = filtered[index];
                      final isArchived = iniciativa.status == 'archivada';
                      return Dismissible(
                        key: ValueKey(iniciativa.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          if (isArchived) {
                            ref.read(iniciativasProvider.notifier).updateIniciativa(
                              iniciativa.copyWith(status: 'activa'),
                            );
                            if (!context.mounted) return false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Iniciativa restaurada'),
                                action: SnackBarAction(
                                  label: 'Deshacer',
                                  textColor: AppColors.accent,
                                  onPressed: () {
                                    ref.read(iniciativasProvider.notifier).archiveIniciativa(iniciativa.id);
                                  },
                                ),
                              ),
                            );
                            return true;
                          }
                          ref
                              .read(iniciativasProvider.notifier)
                              .archiveIniciativa(iniciativa.id);
                          if (!context.mounted) return false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Iniciativa archivada'),
                              action: SnackBarAction(
                                label: 'Deshacer',
                                textColor: AppColors.accent,
                                onPressed: () {
                                  ref.read(iniciativasProvider.notifier).updateIniciativa(
                                    iniciativa.copyWith(status: 'activa'),
                                  );
                                },
                              ),
                            ),
                          );
                          return true;
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: isArchived ? AppColors.success.withOpacity(0.8) : AppColors.error.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isArchived ? Icons.restore_outlined : Icons.archive,
                            color: Colors.white,
                          ),
                        ),
                        child: _IniciativaCard(
                          title: iniciativa.title,
                          description: iniciativa.description,
                          quadrantLabel: iniciativa.computedQuadrant,
                          isArchived: isArchived,
                          onTap: () => context.push(
                            '${AppRoutes.iniciativas}/${iniciativa.id}',
                          ),
                          onRestore: isArchived
                              ? () {
                                  ref.read(iniciativasProvider.notifier).updateIniciativa(
                                    iniciativa.copyWith(status: 'activa'),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Iniciativa restaurada')),
                                  );
                                }
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.iniciativasCreate),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String label, BuildContext context) {
    final selected = _filter == label;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = label),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.of(context).textSecondary,
        fontSize: S.sp(context, 13),
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.of(context).surface,
      side: BorderSide(color: AppColors.of(context).border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _IniciativaCard extends StatelessWidget {
  final String title;
  final String? description;
  final String quadrantLabel;
  final bool isArchived;
  final VoidCallback onTap;
  final VoidCallback? onRestore;

  const _IniciativaCard({
    required this.title,
    required this.description,
    required this.quadrantLabel,
    this.isArchived = false,
    required this.onTap,
    this.onRestore,
  });

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
                      title,
                      style: TextStyle(
                        fontSize: S.sp(context, 16),
                        fontWeight: FontWeight.w600,
                        color: isArchived ? AppColors.of(context).textSecondary : AppColors.of(context).textPrimary,
                        decoration: isArchived ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: S.w(context, 0.02)),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: S.w(context, 0.02), vertical: S.h(context, 0.005)),
                    decoration: BoxDecoration(
                      color: IgoCalculator.colorFromString(quadrantLabel).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quadrantLabel,
                        style: TextStyle(
                          fontSize: S.sp(context, 11),
                          fontWeight: FontWeight.w600,
                          color: IgoCalculator.colorFromString(quadrantLabel),
                      ),
                    ),
                  ),
                ],
              ),
              if (description?.isNotEmpty == true) ...[
                SizedBox(height: S.h(context, 0.01)),
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: S.sp(context, 13),
                    color: AppColors.of(context).textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (isArchived && onRestore != null) ...[
                SizedBox(height: S.h(context, 0.015)),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onRestore,
                    icon: const Icon(Icons.restore_outlined, size: 18),
                    label: const Text('Restaurar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.success,
                      side: const BorderSide(color: AppColors.success),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
