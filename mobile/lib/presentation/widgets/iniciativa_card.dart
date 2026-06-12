import 'package:flutter/material.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/presentation/widgets/cuadrante_badge.dart';

class IniciativaCard extends StatelessWidget {
  final IniciativaModel iniciativa;
  final VoidCallback? onTap;

  const IniciativaCard({
    super.key,
    required this.iniciativa,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArchived = iniciativa.status == 'eliminada';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: S.w(context, 0.04), vertical: S.h(context, 0.005)),
      elevation: isArchived ? 1 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isArchived ? AppColors.of(context).border : AppColors.of(context).primaryShade,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(S.w(context, 0.035)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      iniciativa.title,
                      style: TextStyle(
                        fontSize: S.sp(context, 15),
                        fontWeight: FontWeight.w600,
                      color: isArchived
                          ? AppColors.of(context).textSecondary
                          : AppColors.of(context).textPrimary,
                        decoration:
                            isArchived ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isArchived)
                    Icon(Icons.archive_outlined,
                        size: S.sp(context, 18), color: AppColors.of(context).textHint)
                  else
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
              if (iniciativa.computedQuadrant.isNotEmpty) ...[
                SizedBox(height: S.h(context, 0.01)),
                CuadranteBadge(cuadrante: iniciativa.computedQuadrant),
              ],
              if (iniciativa.importance > 0 || iniciativa.governability > 0) ...[
                SizedBox(height: S.h(context, 0.01)),
                Row(
                  children: [
                    _miniIndicator(
                      context,
                      label: 'I',
                      value: iniciativa.importance,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: S.w(context, 0.03)),
                    _miniIndicator(
                      context,
                      label: 'G',
                      value: iniciativa.governability,
                      color: AppColors.accent,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniIndicator(
    BuildContext context, {
    required String label,
    required int value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.015), vertical: S.h(context, 0.003)),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: S.sp(context, 11),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(width: S.w(context, 0.01)),
        Text(
          '$value/10',
          style: TextStyle(
            fontSize: S.sp(context, 12),
            fontWeight: FontWeight.w500,
            color: AppColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}
