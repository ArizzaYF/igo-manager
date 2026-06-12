import 'package:flutter/material.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class ProgressBarWidget extends StatelessWidget {
  final double progreso;
  final double height;
  final bool showPercentage;

  const ProgressBarWidget({
    super.key,
    required this.progreso,
    this.height = 12,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progreso.clamp(0.0, 1.0);
    final percent = (clamped * 100).round();

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: clamped,
              minHeight: height,
              backgroundColor: AppColors.of(context).border,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
        ),
        if (showPercentage) ...[
          SizedBox(width: S.w(context, 0.02)),
          SizedBox(
            width: S.w(context, 0.1),
            child: Text(
              '$percent%',
              style: TextStyle(
                fontSize: height + 2,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ],
    );
  }


}
