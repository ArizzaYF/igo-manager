import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/presentation/providers/iniciativas_provider.dart';

class MatrizIgoScreen extends ConsumerStatefulWidget {
  const MatrizIgoScreen({super.key});

  @override
  ConsumerState<MatrizIgoScreen> createState() => _MatrizIgoScreenState();
}

class _MatrizIgoScreenState extends ConsumerState<MatrizIgoScreen> {
  String _filterQuadrant = 'Todos';
  String _filterStatus = 'Activas';
  final Set<String> _hiddenIds = {};
  bool _showHidden = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureDataLoaded();
    });
  }

  void _ensureDataLoaded() {
    final current = ref.read(iniciativasProvider);
    if (current.isLoading || (current.valueOrNull != null && current.valueOrNull!.isNotEmpty)) return;
    final user = ref.read(authProvider).valueOrNull;
    if (user != null) {
      ref.read(iniciativasProvider.notifier).loadInitiatives(user.id);
    }
  }

  Future<void> _refreshData() async {
    final user = ref.read(authProvider).valueOrNull;
    if (user != null) {
      ref.read(iniciativasProvider.notifier).loadInitiatives(user.id);
    }
  }

  void _toggleHidden(String id) {
    setState(() {
      if (_hiddenIds.contains(id)) {
        _hiddenIds.remove(id);
      } else {
        _hiddenIds.add(id);
      }
    });
  }

  static const _quadranteLabels = ['Todos', 'Hacer ya', 'Estratégico', 'Rutina', 'Descarte'];
  static const _statusLabels = ['Todas', 'Activas', 'Archivadas'];

  String _quadrantFilterKey(String label) {
    switch (label) {
      case 'Hacer ya':
        return 'hacer_ya';
      case 'Estratégico':
        return 'estrategico_aliados';
      case 'Rutina':
        return 'rutina';
      case 'Descarte':
        return 'descarte';
      default:
        return '';
    }
  }

  bool _iniciativaMatchesQuadrant(IniciativaModel i, String quadrantKey) {
    return i.quadrant == quadrantKey ||
        IgoCalculator.getQuadrantDbKey(
          IgoCalculator.calculateQuadrant(i.importance, i.governability),
        ) == quadrantKey;
  }

  List<IniciativaModel> _filtered(List<IniciativaModel> iniciativas) {
    var result = iniciativas;
    if (_filterQuadrant != 'Todos') {
      final key = _quadrantFilterKey(_filterQuadrant);
      result = result.where((i) => _iniciativaMatchesQuadrant(i, key)).toList();
    }
    if (_filterStatus == 'Activas') {
      result = result.where((i) => i.status == 'activa').toList();
    } else if (_filterStatus == 'Archivadas') {
      result = result.where((i) => i.status == 'archivada').toList();
    }
    if (!_showHidden) {
      result = result.where((i) => !_hiddenIds.contains(i.id)).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final iniciativasAsync = ref.watch(iniciativasProvider);
    final iniciativas = iniciativasAsync.valueOrNull ?? [];
    final filtered = _filtered(iniciativas);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.igoMatrizTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(S.w(context, 0.04), S.h(context, 0.015), S.w(context, 0.04), S.h(context, 0.005)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _quadranteLabels.map((label) {
                      final selected = _filterQuadrant == label;
                      return Padding(
                        padding: EdgeInsets.only(right: S.w(context, 0.02)),
                        child: FilterChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _filterQuadrant = label),
                          selectedColor: AppColors.primary,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppColors.of(context).textPrimary,
                            fontSize: S.sp(context, 12),
                          ),
                          backgroundColor: AppColors.of(context).primaryShade,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                  SizedBox(height: S.h(context, 0.01)),
                  Row(
                  children: [
                    ..._statusLabels.map((label) {
                      final selected = _filterStatus == label;
                      return Padding(
                        padding: EdgeInsets.only(right: S.w(context, 0.02)),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _filterStatus = label),
                          selectedColor: AppColors.accent,
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.of(context).textSecondary,
                            fontSize: S.sp(context, 12),
                            fontWeight: FontWeight.w500,
                          ),
                          backgroundColor: AppColors.of(context).surface,
                          side: BorderSide(color: AppColors.of(context).border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    if (_hiddenIds.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _showHidden = !_showHidden),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.025), vertical: S.h(context, 0.008)),
                          decoration: BoxDecoration(
                            color: _showHidden ? AppColors.accent : AppColors.of(context).surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.of(context).border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _showHidden ? Icons.visibility : Icons.visibility_off,
                                size: 16,
                                color: _showHidden ? AppColors.primary : AppColors.of(context).textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_hiddenIds.length}',
                                style: TextStyle(
                                  fontSize: S.sp(context, 12),
                                  fontWeight: FontWeight.w600,
                                  color: _showHidden ? AppColors.primary : AppColors.of(context).textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: iniciativasAsync.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                          padding: EdgeInsets.all(S.w(context, 0.04)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.of(context).surface,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.of(context).border),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CustomPaint(
                                        size: Size(constraints.maxWidth,
                                            constraints.maxHeight),
                                        painter: _MatrizPainter(isDark: Theme.of(context).brightness == Brightness.dark),
                                        child: Stack(
                                          children: [
                                            ..._generatePoints(
                                                constraints, filtered),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: S.h(context, 0.02)),
                            _buildLegend(),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static const _scatterOffsets = <Offset>[
    Offset(0, 0),
    Offset(10, 0),
    Offset(0, 10),
    Offset(-10, 0),
    Offset(0, -10),
    Offset(10, 10),
    Offset(-10, 10),
    Offset(10, -10),
    Offset(-10, -10),
    Offset(16, 0),
    Offset(0, 16),
    Offset(-16, 0),
    Offset(0, -16),
    Offset(16, 16),
    Offset(-16, 16),
    Offset(16, -16),
    Offset(-16, -16),
    Offset(20, 0),
    Offset(0, 20),
  ];

  void _showClusterModal(String key, List<IniciativaModel> iniciativas) {
    final clustered = iniciativas.where((i) =>
        '${i.importance}_${i.governability}' == key).toList();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(S.w(context, 0.05)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: S.w(context, 0.1), height: S.h(context, 0.005),
                decoration: BoxDecoration(
                  color: AppColors.of(context).textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: S.h(context, 0.02)),
            Text(
              '${clustered.length} iniciativas en este punto',
              style: TextStyle(
                fontSize: S.sp(context, 16), fontWeight: FontWeight.bold,
                color: AppColors.of(context).textPrimary,
              ),
            ),
            SizedBox(height: S.h(context, 0.015)),
            ...clustered.map((i) => ListTile(
              leading: Container(
                width: S.w(context, 0.03), height: S.w(context, 0.03),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: IgoCalculator.colorFromString(i.quadrant ?? i.computedQuadrant),
                ),
              ),
              title: Text(i.title, style: TextStyle(fontSize: S.sp(context, 14))),
              subtitle: Text('I: ${i.importance ~/ 2}  G: ${i.governability ~/ 2}',
                style: TextStyle(fontSize: S.sp(context, 12))),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.iniciativaDetail.replaceFirst(':id', i.id));
              },
            )),
          ],
        ),
      ),
    );
  }

  List<Widget> _generatePoints(
      BoxConstraints constraints, List<IniciativaModel> iniciativas) {
    final offsetMap = <String, int>{};
    final addedCluster = <String>{};
    return iniciativas.map((iniciativa) {
      final key =
          '${iniciativa.importance}_${iniciativa.governability}';
      final index = offsetMap[key] ?? 0;
      offsetMap[key] = index + 1;
      final totalAtCoord = offsetMap[key]!;

      const matrixPadding = 0.15;
      final usableW = constraints.maxWidth * (1 - 2 * matrixPadding);
      final usableH = constraints.maxHeight * (1 - 2 * matrixPadding);
      final baseX = matrixPadding * constraints.maxWidth +
          (iniciativa.governability - 1) / 9.0 * usableW;
      final baseY = matrixPadding * constraints.maxHeight +
          (10.0 - iniciativa.importance) / 9.0 * usableH;

      final scatter = _scatterOffsets[index % _scatterOffsets.length];
      final isHidden = _hiddenIds.contains(iniciativa.id);
      final pointSize = isHidden ? 12.0 : 16.0;
      final halfSize = pointSize / 2;

      final x = (baseX + scatter.dx - halfSize)
          .clamp(0.0, constraints.maxWidth - pointSize);
      final y = (baseY + scatter.dy - halfSize)
          .clamp(0.0, constraints.maxHeight - pointSize);

      final color = IgoCalculator.colorFromString(iniciativa.quadrant ?? iniciativa.computedQuadrant);
      final pointColor = isHidden ? AppColors.of(context).textHint : color;
      final imp = iniciativa.importance ~/ 2;
      final gov = iniciativa.governability ~/ 2;

      final isFirst = index == 0;

      return Positioned(
        left: x,
        top: y,
        child: GestureDetector(
          onTap: () {
            if (totalAtCoord > 1 && addedCluster.add(key)) {
              _showClusterModal(key, iniciativas);
            } else {
              context.push(AppRoutes.iniciativaDetail.replaceFirst(':id', iniciativa.id));
            }
          },
          onLongPress: () => _toggleHidden(iniciativa.id),
          child: Tooltip(
              message: isHidden
                  ? '${iniciativa.title}\nI: $imp  G: $gov (tocar para mostrar)'
                  : '${iniciativa.title}\nI: $imp  G: $gov',
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: pointSize,
                    height: pointSize,
                    decoration: BoxDecoration(
                      color: pointColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.of(context).surface, width: isHidden ? 1 : 2),
                      boxShadow: isHidden ? null : [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  if (isHidden)
                    const Icon(Icons.close, size: 8, color: Colors.white),
                  if (!isHidden && isFirst)
                    Positioned(
                      top: -10,
                      child: Text(
                        '$imp,$gov',
                        style: TextStyle(
                          fontSize: S.sp(context, 9),
                          fontWeight: FontWeight.bold,
                          color: color,
                          backgroundColor: AppColors.of(context).surface.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  if (!isHidden && totalAtCoord > 1 && isFirst)
                    Positioned(
                      right: -6,
                      bottom: -6,
                      child: Container(
                        padding: EdgeInsets.all(S.w(context, 0.008)),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.of(context).surface, width: 1.5),
                        ),
                        child: Text(
                          '$totalAtCoord',
                          style: TextStyle(
                            fontSize: S.sp(context, 9),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem(AppColors.hacerYa, AppStrings.hacerYa),
        _legendItem(AppColors.estrategico, 'Estrat.'),
        _legendItem(AppColors.rutina, AppStrings.rutina),
        _legendItem(AppColors.descarte, AppStrings.descarte),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: S.w(context, 0.03),
          height: S.w(context, 0.03),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: S.w(context, 0.015)),
        Text(
          label,
          style: TextStyle(
            fontSize: S.sp(context, 11),
            color: AppColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MatrizPainter extends CustomPainter {
  final bool isDark;
  const _MatrizPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.hacerYa.withValues(alpha: 0.08);
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height / 2),
      paint,
    );

    paint.color = AppColors.estrategico.withValues(alpha: 0.08);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width / 2, size.height / 2),
      paint,
    );

    paint.color = AppColors.rutina.withValues(alpha: 0.08);
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2, size.height / 2, size.width / 2,
          size.height / 2),
      paint,
    );

    paint.color = AppColors.descarte.withValues(alpha: 0.08);
    canvas.drawRect(
      Rect.fromLTWH(
          0, size.height / 2, size.width / 2, size.height / 2),
      paint,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = isDark ? AppColors.darkBorder : AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    final textStyle = TextStyle(
      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    for (int i = 1; i <= 5; i++) {
      final x = (i - 1) / 4.0 * size.width;
      final y = (i - 1) / 4.0 * size.height;
      _drawLabel(canvas, '$i', x - 4, size.height * 0.48, textStyle);
      _drawLabel(canvas, '$i', size.width * 0.45, y - 4, textStyle);
    }
    _drawLabel(canvas, 'Baja Gob.', size.width * 0.02, size.height * 0.48, textStyle);
    _drawLabel(canvas, 'Alta Gob.', size.width * 0.82, size.height * 0.48, textStyle);
    _drawLabel(canvas, 'Alta Imp.', size.width * 0.45, size.height * 0.01, textStyle);
    _drawLabel(canvas, 'Baja Imp.', size.width * 0.45, size.height * 0.92, textStyle);
  }

  void _drawLabel(Canvas canvas, String text, double x, double y, TextStyle style) {
    final builder = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    builder.layout();
    builder.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
