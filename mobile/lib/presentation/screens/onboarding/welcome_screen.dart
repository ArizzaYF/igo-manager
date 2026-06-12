import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.06)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: S.h(context, 0.04)),
                Container(
                  width: S.w(context, 0.25),
                  height: S.w(context, 0.25),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.grid_view_rounded,
                    size: S.w(context, 0.14),
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(height: S.h(context, 0.025)),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: S.sp(context, 28),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: S.h(context, 0.01)),
                Text(
                  AppStrings.tagline,
                  style: TextStyle(
                    fontSize: S.sp(context, 15),
                    color: AppColors.of(context).textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: S.h(context, 0.04)),
                Container(
                  padding: EdgeInsets.all(S.w(context, 0.06)),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryShade,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.dashboard_customize_rounded,
                        size: S.w(context, 0.16),
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      SizedBox(height: S.h(context, 0.015)),
                      const Text(
                        'Importancia vs Gobernabilidad',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: S.h(context, 0.008)),
                      Text(
                        AppStrings.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: S.sp(context, 13),
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: S.h(context, 0.04)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoutes.registerStep1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Comenzar Registro',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.015)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.login),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextButton(
                  onPressed: () => context.push(AppRoutes.terms),
                  child: Text(
                    'Términos y condiciones',
                    style: TextStyle(
                      color: AppColors.of(context).textSecondary,
                      fontSize: S.sp(context, 12),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.02)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
