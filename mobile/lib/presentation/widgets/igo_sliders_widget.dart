import 'package:flutter/material.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class IgoSlidersWidget extends StatefulWidget {
  final int initialImportance;
  final int initialGovernability;
  final ValueChanged<int>? onImportanceChanged;
  final ValueChanged<int>? onGovernabilityChanged;
  final VoidCallback? onBothChanged;

  const IgoSlidersWidget({
    super.key,
    this.initialImportance = 5,
    this.initialGovernability = 5,
    this.onImportanceChanged,
    this.onGovernabilityChanged,
    this.onBothChanged,
  });

  @override
  State<IgoSlidersWidget> createState() => _IgoSlidersWidgetState();
}

class _IgoSlidersWidgetState extends State<IgoSlidersWidget> {
  late int _importance;
  late int _governability;

  @override
  void initState() {
    super.initState();
    _importance = widget.initialImportance;
    _governability = widget.initialGovernability;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _sliderColumn(
                'Importancia',
                _importance,
                AppColors.primary,
                (v) {
                  setState(() {
                    _importance = v;
                    widget.onImportanceChanged?.call(v);
                    widget.onBothChanged?.call();
                  });
                },
              ),
            ),
            SizedBox(width: S.w(context, 0.06)),
            Expanded(
              child: _sliderColumn(
                'Gobernabilidad',
                _governability,
                AppColors.accent,
                (v) {
                  setState(() {
                    _governability = v;
                    widget.onGovernabilityChanged?.call(v);
                    widget.onBothChanged?.call();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _miniMatrixPreview(_importance, _governability),
        const SizedBox(height: 12),
        _quadrantResult(_importance, _governability),
      ],
    );
  }

  Widget _sliderColumn(
    String label,
    int value,
    Color color,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      children: [
        Text(
          '$label: $value/10',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: S.h(context, 0.22),
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: color,
                inactiveTrackColor: color.withOpacity(0.2),
                thumbColor: color,
                overlayColor: color.withOpacity(0.12),
                trackHeight: 6,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10),
                valueIndicatorColor: color,
                valueIndicatorTextStyle: const TextStyle(
                  color: AppColors.textOnPrimary,
                ),
              ),
              child: Slider(
                value: value.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: value.toString(),
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniMatrixPreview(int imp, int gov) {
    final cuadrante = IgoCalculator.calculateQuadrant(imp, gov);
    final color = IgoCalculator.getQuadrantColor(cuadrante);

    return Container(
      width: S.w(context, 0.35),
      height: S.w(context, 0.35),
      decoration: BoxDecoration(
        color: AppColors.of(context).primaryShade,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.of(context).border),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter(borderColor: AppColors.of(context).border))),
          Positioned(
            left: (imp / 10) * 100 - 8,
            top: ((10 - gov) / 10) * 100 - 8,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: AppColors.of(context).surface, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          ..._miniLabels(context),
        ],
      ),
    );
  }

  List<Widget> _miniLabels(BuildContext context) {
    final style = TextStyle(fontSize: 7, color: AppColors.of(context).textHint);
    return [
      Positioned(left: 2, top: 2, child: Text('R', style: style)),
      Positioned(right: 2, top: 2, child: Text('HY', style: style)),
      Positioned(left: 2, bottom: 2, child: Text('D', style: style)),
      Positioned(right: 2, bottom: 2, child: Text('E', style: style)),
    ];
  }

  Widget _quadrantResult(int imp, int gov) {
    final cuadrante = IgoCalculator.calculateQuadrant(imp, gov);
    final color = IgoCalculator.getQuadrantColor(cuadrante);
    final label = IgoCalculator.getQuadrantLabel(cuadrante);
    final icon = _cuadranteIcon(cuadrante);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _cuadranteIcon(IgoQuadrant cuadrante) {
    switch (cuadrante) {
      case IgoQuadrant.hacerYa:
        return Icons.check_circle_outline;
      case IgoQuadrant.estrategicoAliados:
        return Icons.groups_outlined;
      case IgoQuadrant.rutina:
        return Icons.refresh_outlined;
      case IgoQuadrant.descarte:
        return Icons.delete_outline;
    }
  }
}

class _GridPainter extends CustomPainter {
  final Color borderColor;
  const _GridPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 0.5;

    final midX = size.width / 2;
    final midY = size.height / 2;

    canvas.drawLine(Offset(midX, 0), Offset(midX, size.height), paint);
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
