import 'dart:ui';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

enum IgoQuadrant { hacerYa, estrategicoAliados, rutina, descarte }

class IgoCalculator {
  IgoCalculator._();

  static IgoQuadrant calculateQuadrant(int importance, int governability) {
    if (importance >= 6 && governability >= 6) {
      return IgoQuadrant.hacerYa;
    } else if (importance >= 6 && governability < 6) {
      return IgoQuadrant.estrategicoAliados;
    } else if (importance < 6 && governability >= 6) {
      return IgoQuadrant.rutina;
    } else {
      return IgoQuadrant.descarte;
    }
  }

  static String getQuadrantLabel(IgoQuadrant quadrant) {
    switch (quadrant) {
      case IgoQuadrant.hacerYa:
        return AppStrings.hacerYa;
      case IgoQuadrant.estrategicoAliados:
        return AppStrings.estrategico;
      case IgoQuadrant.rutina:
        return AppStrings.rutina;
      case IgoQuadrant.descarte:
        return AppStrings.descarte;
    }
  }

  static String getQuadrantDbKey(IgoQuadrant quadrant) {
    switch (quadrant) {
      case IgoQuadrant.hacerYa:
        return 'hacer_ya';
      case IgoQuadrant.estrategicoAliados:
        return 'estrategico_aliados';
      case IgoQuadrant.rutina:
        return 'rutina';
      case IgoQuadrant.descarte:
        return 'descarte';
    }
  }

  static String dbKeyToLabel(String dbKey) {
    switch (dbKey) {
      case 'hacer_ya':
        return AppStrings.hacerYa;
      case 'estrategico_aliados':
        return AppStrings.estrategico;
      case 'rutina':
        return AppStrings.rutina;
      case 'descarte':
        return AppStrings.descarte;
      default:
        return dbKey;
    }
  }

  static String getSuggestedAction(IgoQuadrant quadrant) {
    switch (quadrant) {
      case IgoQuadrant.hacerYa:
        return AppStrings.hacerYaDesc;
      case IgoQuadrant.estrategicoAliados:
        return AppStrings.estrategicoDesc;
      case IgoQuadrant.rutina:
        return AppStrings.rutinaDesc;
      case IgoQuadrant.descarte:
        return AppStrings.descarteDesc;
    }
  }

  static Color getQuadrantColor(IgoQuadrant quadrant) {
    switch (quadrant) {
      case IgoQuadrant.hacerYa:
        return AppColors.hacerYa;
      case IgoQuadrant.estrategicoAliados:
        return AppColors.estrategico;
      case IgoQuadrant.rutina:
        return AppColors.rutina;
      case IgoQuadrant.descarte:
        return AppColors.descarte;
    }
  }

  static Color colorFromString(String? quadrant) {
    if (quadrant == null) return AppColors.textHint;
    switch (quadrant) {
      case 'hacer_ya':
      case 'Hacer ya':
        return AppColors.hacerYa;
      case 'estrategico_aliados':
      case 'Estratégico':
        return AppColors.estrategico;
      case 'rutina':
      case 'Rutina':
        return AppColors.rutina;
      case 'descarte':
      case 'Descarte':
        return AppColors.descarte;
      default:
        return AppColors.textHint;
    }
  }
}
