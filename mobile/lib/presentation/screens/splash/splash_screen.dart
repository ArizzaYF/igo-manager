import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    Future.microtask(() => ref.read(authProvider.notifier).checkSession());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      if (_navigated) return;
      if (prev?.isLoading == true && !next.isLoading) {
        _navigated = true;
        final user = next.valueOrNull;
        if (user != null) {
          context.go(AppRoutes.iniciativas);
        } else {
          context.go(AppRoutes.welcome);
        }
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: S.w(context, 0.3),
                height: S.w(context, 0.3),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: S.sp(context, 64),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: S.h(context, 0.03)),
              Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: S.sp(context, 32),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: S.h(context, 0.015)),
              Text(
                AppStrings.tagline,
                style: TextStyle(
                  fontSize: S.sp(context, 16),
                  color: Colors.white.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: S.h(context, 0.04)),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
