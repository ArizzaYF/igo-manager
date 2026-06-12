import 'package:flutter/material.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class CuadranteBadge extends StatelessWidget {
  final String cuadrante;
  final double fontSize;

  const CuadranteBadge({
    super.key,
    required this.cuadrante,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.02), vertical: S.h(context, 0.004)),
      decoration: BoxDecoration(
        color: _color(context).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color(context).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: fontSize + 2, color: _color(context)),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: _color(context),
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    if (cuadrante.contains('Hacer')) return 'Hacer ya';
    if (cuadrante.contains('Estrat')) return 'Estratégico';
    if (cuadrante.contains('Rutina')) return 'Rutina';
    if (cuadrante.contains('Descarte')) return 'Descarte';
    return 'Sin calificar';
  }

  Color _color(BuildContext context) {
    if (cuadrante.contains('Hacer')) return AppColors.hacerYa;
    if (cuadrante.contains('Estrat')) return AppColors.estrategico;
    if (cuadrante.contains('Rutina')) return AppColors.rutina;
    if (cuadrante.contains('Descarte')) return AppColors.descarte;
    return AppColors.of(context).textHint;
  }

  IconData get _icon {
    if (cuadrante.contains('Hacer')) return Icons.check_circle_outline;
    if (cuadrante.contains('Estrat')) return Icons.groups_outlined;
    if (cuadrante.contains('Rutina')) return Icons.refresh_outlined;
    if (cuadrante.contains('Descarte')) return Icons.delete_outline;
    return Icons.help_outline;
  }
}
