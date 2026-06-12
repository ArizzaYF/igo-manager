import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';

class IgoSlidersScreen extends ConsumerStatefulWidget {
  final String id;
  const IgoSlidersScreen({required this.id, super.key});

  @override
  ConsumerState<IgoSlidersScreen> createState() => _IgoSlidersScreenState();
}

class _IgoSlidersScreenState extends ConsumerState<IgoSlidersScreen>
    with SingleTickerProviderStateMixin {
  double _importance = 3;
  double _governability = 3;
  bool _isSaving = false;
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int get _mappedImportance => (_importance * 2).round();
  int get _mappedGovernability => (_governability * 2).round();
  IgoQuadrant get _computedQuadrant => IgoCalculator.calculateQuadrant(_mappedImportance, _mappedGovernability);

  String get _quadrant => IgoCalculator.getQuadrantLabel(_computedQuadrant);

  String get _action => IgoCalculator.getSuggestedAction(_computedQuadrant);

  Color get _quadrantColor => IgoCalculator.getQuadrantColor(_computedQuadrant);

  IconData get _quadrantIcon {
    switch (_computedQuadrant) {
      case IgoQuadrant.hacerYa:
        return Icons.rocket_launch_rounded;
      case IgoQuadrant.estrategicoAliados:
        return Icons.handshake_rounded;
      case IgoQuadrant.rutina:
        return Icons.replay_rounded;
      case IgoQuadrant.descarte:
        return Icons.block_rounded;
    }
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);
    await ref.read(iniciativasProvider.notifier).rateIniciativa(
      iniciativaId: widget.id,
      importance: _mappedImportance,
      governability: _mappedGovernability,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clasificación guardada exitosamente'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.igoTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(S.w(context, 0.06)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSliderSection(context),
            SizedBox(height: S.h(context, 0.04)),
            AnimatedBuilder(
              animation: _anim,
              builder: (context, child) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: EdgeInsets.all(S.w(context, 0.06)),
                decoration: BoxDecoration(
                  color: _quadrantColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _quadrantColor.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _quadrantIcon,
                      size: S.w(context, 0.12),
                      color: _quadrantColor,
                    ),
                    SizedBox(height: S.h(context, 0.015)),
                    Text(
                      _quadrant,
                      style: TextStyle(
                        fontSize: S.sp(context, 20),
                        fontWeight: FontWeight.bold,
                        color: _quadrantColor,
                      ),
                    ),
                    SizedBox(height: S.h(context, 0.01)),
                    Text(
                      _action,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: S.sp(context, 13),
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: S.h(context, 0.04)),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
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
                        'Guardar Clasificación',
                        style: TextStyle(
                            fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection(BuildContext context) {
    return Column(
      children: [
        _buildSlider(
          context: context,
          label: AppStrings.igoImportance,
          value: _importance,
          color: AppColors.primary,
          onChanged: (v) {
            setState(() => _importance = v);
            _animController.reset();
            _animController.forward();
          },
        ),
        SizedBox(height: S.h(context, 0.01)),
        _buildSlider(
          context: context,
          label: AppStrings.igoGovernability,
          value: _governability,
          color: AppColors.accent,
          onChanged: (v) {
            setState(() => _governability = v);
            _animController.reset();
            _animController.forward();
          },
        ),
      ],
    );
  }

  Widget _buildSlider({
    required BuildContext context,
    required String label,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: S.sp(context, 15),
                fontWeight: FontWeight.w600,
                color: AppColors.of(context).textPrimary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.03), vertical: S.h(context, 0.005)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: S.sp(context, 14),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.2),
            thumbColor: color,
            overlayColor: color.withOpacity(0.1),
            valueIndicatorColor: color,
            valueIndicatorTextStyle: const TextStyle(color: AppColors.textOnPrimary),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            label: value.toStringAsFixed(0),
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.04)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bajo', style: TextStyle(fontSize: S.sp(context, 11), color: AppColors.of(context).textHint)),
              Text('Alto', style: TextStyle(fontSize: S.sp(context, 11), color: AppColors.of(context).textHint)),
            ],
          ),
        ),
      ],
    );
  }
}
