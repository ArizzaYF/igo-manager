import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _errorMessage = null;
    });
    await ref.read(authProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    final authState = ref.read(authProvider);
    authState.whenOrNull(
      data: (user) {
        if (user != null) {
          context.go(AppRoutes.iniciativas);
        }
      },
      error: (err, _) {
        setState(() => _errorMessage = err.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.06)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: S.h(context, 0.02)),
                Center(
                  child: Container(
                    width: S.w(context, 0.2),
                    height: S.w(context, 0.2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: S.w(context, 0.11),
                      color: AppColors.accent,
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.03)),
                Center(
                  child: Text(
                    AppStrings.loginTitle,
                    style: TextStyle(
                      fontSize: S.sp(context, 24),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.04)),
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(S.w(context, 0.03)),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: S.sp(context, 13),
                      ),
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.02)),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.loginEmail,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(v.trim())) {
                      return AppStrings.invalidEmail;
                    }
                    return null;
                  },
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppStrings.loginPassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.01)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Funcionalidad próximamente')),
                      );
                    },
                    child: Text(
                      AppStrings.loginForgotPassword,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: S.sp(context, 13),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.02)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppStrings.loginButton,
                            style: TextStyle(
                                fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                SizedBox(height: S.h(context, 0.03)),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppStrings.loginNoAccount} ',
                        style: TextStyle(
                          color: AppColors.of(context).textSecondary,
                          fontSize: S.sp(context, 14),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.welcome),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: S.sp(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: S.h(context, 0.03)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
