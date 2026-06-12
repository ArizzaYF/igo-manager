import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/data/models/plan_accion_model.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/presentation/widgets/progress_bar_widget.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final String iniciativaTitulo;
  final VoidCallback? onTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.iniciativaTitulo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = plan.deadlineAt != null
        ? plan.deadlineAt!.difference(DateTime.now()).inDays
        : null;
    final dateFormat = DateFormat('MMM dd, yyyy', 'es_CO');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: S.w(context, 0.04), vertical: S.h(context, 0.005)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(S.w(context, 0.035)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                iniciativaTitulo,
                style: TextStyle(
                  fontSize: S.sp(context, 15),
                  fontWeight: FontWeight.w600,
                  color: AppColors.of(context).textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: S.h(context, 0.01)),
              Row(
                children: [
                  if (plan.deadlineAt != null) ...[
                    Icon(
                      Icons.calendar_today_outlined,
                      size: S.sp(context, 14),
                      color: daysRemaining != null && daysRemaining < 0
                          ? AppColors.error
                          : daysRemaining != null && daysRemaining <= 3
                              ? AppColors.warning
                              : AppColors.of(context).textSecondary,
                    ),
                    SizedBox(width: S.w(context, 0.015)),
                    Text(
                      dateFormat.format(plan.deadlineAt!),
                      style: TextStyle(
                        fontSize: S.sp(context, 12),
                        color: daysRemaining != null && daysRemaining < 0
                            ? AppColors.error
                            : AppColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (daysRemaining != null) _daysBadge(daysRemaining, context),
                  SizedBox(width: S.w(context, 0.02)),
                  _statusBadge(plan.status, context),
                ],
              ),
              SizedBox(height: S.h(context, 0.012)),
              ProgressBarWidget(progreso: plan.progressPercent / 100.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _daysBadge(int days, BuildContext context) {
    Color color;
    String text;
    if (days < 0) {
      color = AppColors.error;
      text = '${days.abs()} días vencidos';
    } else if (days == 0) {
      color = AppColors.warning;
      text = 'Vence hoy';
    } else if (days == 1) {
      color = AppColors.warning;
      text = '1 día restante';
    } else {
      color = AppColors.of(context).textSecondary;
      text = '$days días restantes';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.02), vertical: S.h(context, 0.003)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: S.sp(context, 11),
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _statusBadge(String estado, BuildContext context) {
    final data = _statusData(estado, context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.02), vertical: S.h(context, 0.003)),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        data.label,
        style: TextStyle(
          fontSize: S.sp(context, 11),
          fontWeight: FontWeight.w600,
          color: data.color,
        ),
      ),
    );
  }

  _StatusData _statusData(String estado, BuildContext context) {
    switch (estado) {
      case 'pendiente':
        return _StatusData('Pendiente', AppColors.warning);
      case 'en_progreso':
        return _StatusData('En Progreso', AppColors.info);
      case 'completado':
        return _StatusData('Completado', AppColors.success);
      case 'abortado':
        return _StatusData('Cancelado', AppColors.error);
      default:
        return _StatusData(estado, AppColors.of(context).textSecondary);
    }
  }
}

class _StatusData {
  final String label;
  final Color color;
  const _StatusData(this.label, this.color);
}
