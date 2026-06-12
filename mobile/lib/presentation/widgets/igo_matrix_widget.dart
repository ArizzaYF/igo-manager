import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';

class IgoMatrixWidget extends StatelessWidget {
  final List<IniciativaModel> iniciativas;
  final void Function(IniciativaModel)? onPointTap;

  const IgoMatrixWidget({
    super.key,
    required this.iniciativas,
    this.onPointTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: _buildSpots(context),
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 11,
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              if (value == 5.5) {
                return FlLine(
                  color: AppColors.of(context).textSecondary,
                  strokeWidth: 2,
                );
              }
              return FlLine(
                color: AppColors.of(context).border,
                strokeWidth: 0.5,
              );
            },
            getDrawingVerticalLine: (value) {
              if (value == 5.5) {
                return FlLine(
                  color: AppColors.of(context).textSecondary,
                  strokeWidth: 2,
                );
              }
              return FlLine(
                color: AppColors.of(context).border,
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AppColors.of(context).border),
          ),
          scatterTouchData: ScatterTouchData(
            enabled: true,
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipColor: (_) => AppColors.primary,
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpot) {
                final index = iniciativas.indexWhere(
                  (i) => i.importance == touchedSpot.x.toInt() &&
                      i.governability == touchedSpot.y.toInt(),
                );
                if (index == -1) return null;
                return ScatterTooltipItem(
                  iniciativas[index].title,
                  textStyle: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: S.sp(context, 12),
                  ),
                );
              },
            ),
            handleBuiltInTouches: true,
            touchCallback: (event, response) {
              if (event.isInterestedForInteractions &&
                  response != null &&
                  response.touchedSpot != null &&
                  onPointTap != null) {
                final index = response.touchedSpot!.spotIndex;
                onPointTap!(iniciativas[index]);
              }
            },
          ),
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  List<ScatterSpot> _buildSpots(BuildContext context) {
    return iniciativas.asMap().entries.map((entry) {
      final i = entry.value;
      final quad = IgoCalculator.calculateQuadrant(
        i.importance,
        i.governability,
      );
      final color = IgoCalculator.getQuadrantColor(quad);
      return ScatterSpot(
        i.importance.toDouble(),
        i.governability.toDouble(),
        dotPainter: FlDotCirclePainter(
          radius: S.w(context, 0.02),
          color: color,
          strokeColor: color.withOpacity(0.6),
          strokeWidth: 1,
        ),
      );
    }).toList();
  }
}
