import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

final _registroTempProvider = StateProvider.autoDispose<Map<String, String>>(
  (ref) => {},
);

class RegisterStep1Screen extends ConsumerStatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  ConsumerState<RegisterStep1Screen> createState() =>
      _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends ConsumerState<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text,
    };
    ref.read(_registroTempProvider.notifier).update((_) => data);
    context.push(AppRoutes.registerStep2, extra: data);
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: S.h(context, 0.01)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryShade,
                    borderRadius: BorderRadius.circular(20),
                  ),
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      const Text(
                        'Paso 1 de 2',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: S.h(context, 0.02)),
                Text(
                  AppStrings.registerTitle,
                  style: TextStyle(
                    fontSize: S.sp(context, 24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: S.h(context, 0.005)),
                Text(
                  AppStrings.registerSubtitle,
                  style: TextStyle(
                    fontSize: S.sp(context, 14),
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
                SizedBox(height: S.h(context, 0.035)),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.registerFullName,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.registerEmail,
                    hintText: AppStrings.registerEmailHint,
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
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.registerPhone,
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    final phoneRegex = RegExp(r'^[0-9+ ]{7,20}$');
                    if (!phoneRegex.hasMatch(v.trim())) {
                      return 'Solo dígitos, + y espacios (7-20)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppStrings.registerPassword,
                    hintText: AppStrings.registerPasswordHint,
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
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    if (v.length < 8) {
                      return AppStrings.invalidPassword;
                    }
                    return null;
                  },
                ),
                SizedBox(height: S.h(context, 0.02)),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: AppStrings.registerConfirmPassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    if (v != _passwordController.text) {
                      return AppStrings.passwordMismatch;
                    }
                    return null;
                  },
                ),
                SizedBox(height: S.h(context, 0.04)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.registerNext,
                      style:
                          TextStyle(fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
                    ),
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
