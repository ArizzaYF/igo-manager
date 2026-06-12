import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class RegisterStep2Screen extends ConsumerStatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  ConsumerState<RegisterStep2Screen> createState() =>
      _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends ConsumerState<RegisterStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  String? _sector;
  String? _companySize;
  String? _ageRange;
  String? _gender;
  bool _acceptTerms = false;
  bool _isLoading = false;

  static const _sectores = [
    'Agro',
    'Calzado/Moda',
    'Tecnología',
    'Servicios',
    'Comercio',
    'Salud',
    'Turismo',
    'Educación',
    'Otro',
  ];

  static const _tamanos = [
    'Idea',
    'Micro <10',
    'Pequeña <50',
    'Mediana <200',
    'Grande',
  ];

  static const _edades = [
    '18-25',
    '26-35',
    '36-45',
    '46-55',
    '+56',
  ];

  static const _generos = [
    'Masculino',
    'Femenino',
    'Otro',
  ];

  @override
  void dispose() {
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos y condiciones')),
      );
      return;
    }
    final step1Data = GoRouterState.of(context).extra as Map<String, String>?;
    if (step1Data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: datos de registro perdidos')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).register(
      email: step1Data['email'] ?? '',
      password: step1Data['password'] ?? '',
      fullName: step1Data['name'] ?? '',
      phone: step1Data['phone'] ?? '',
      companyName: _companyController.text.trim(),
      sector: _sector ?? '',
      companySize: _companySize ?? '',
      ageRange: _ageRange ?? '',
      gender: _gender ?? '',
      termsAccepted: true,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    final authState = ref.read(authProvider);
    authState.whenOrNull(
      data: (user) {
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.registerSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(AppRoutes.login);
        }
      },
      error: (err, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $err'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
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
                        'Paso 2 de 2',
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
                  'Perfil empresarial',
                  style: TextStyle(
                    fontSize: S.sp(context, 24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: S.h(context, 0.005)),
                SizedBox(height: S.h(context, 0.035)),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.registerCompany,
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.02)),
                DropdownButtonFormField<String>(
                  value: _sector,
                  decoration: _dropdownDecoration(AppStrings.registerSector),
                  items: _sectores
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _sector = v),
                  validator: (v) => v == null ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.02)),
                DropdownButtonFormField<String>(
                  value: _companySize,
                  decoration: _dropdownDecoration(AppStrings.registerCompanySize),
                  items: _tamanos
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _companySize = v),
                  validator: (v) => v == null ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.02)),
                DropdownButtonFormField<String>(
                  value: _ageRange,
                  decoration: _dropdownDecoration(AppStrings.registerAgeRange),
                  items: _edades
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (v) => setState(() => _ageRange = v),
                  validator: (v) => v == null ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.02)),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: _dropdownDecoration(AppStrings.registerGender),
                  items: _generos
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v),
                  validator: (v) => v == null ? AppStrings.fieldRequired : null,
                ),
                SizedBox(height: S.h(context, 0.025)),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        activeColor: AppColors.primary,
                        onChanged: (v) =>
                            setState(() => _acceptTerms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.terms),
                        child: Text(
                          AppStrings.registerAcceptTerms,
                          style: TextStyle(
                            fontSize: S.sp(context, 13),
                            color: AppColors.of(context).textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: S.h(context, 0.035)),
                SizedBox(
                  width: double.infinity,
                  height: S.h(context, 0.065),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onCreateAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppStrings.registerFinish,
                            style: TextStyle(
                                fontSize: S.sp(context, 16), fontWeight: FontWeight.w600),
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
