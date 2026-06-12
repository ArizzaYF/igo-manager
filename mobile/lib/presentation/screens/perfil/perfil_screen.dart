import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_routes.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/presentation/providers/auth_provider.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.perfilTitle),
        elevation: 0,
      ),
      body: userAsync.isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.of(context).primary))
          : SingleChildScrollView(
              padding: EdgeInsets.all(S.w(context, 0.06)),
              child: Column(
                children: [
                  SizedBox(height: S.h(context, 0.02)),
                  CircleAvatar(
                    radius: S.w(context, 0.12),
                    backgroundColor: AppColors.of(context).primaryShade,
                    child: Icon(
                      Icons.person,
                      size: S.w(context, 0.12),
                      color: AppColors.of(context).primary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.02)),
                  Text(
                    user?.fullName ?? 'Nombre del Usuario',
                    style: TextStyle(
                      fontSize: S.sp(context, 20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.005)),
                  Text(
                    user?.email ?? 'usuario@correo.com',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.03)),
                  _buildInfoCard(context,
                    children: [
                      _buildInfoRow(context,
                        icon: Icons.business_outlined,
                        label: 'Empresa',
                        value: user?.companyName ?? 'No especificada',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(context,
                        icon: Icons.category_outlined,
                        label: 'Sector',
                        value: user?.sector ?? 'No especificado',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(context,
                        icon: Icons.business_center_outlined,
                        label: 'Tamaño',
                        value: user?.companySize ?? 'No especificado',
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.02)),
                  _buildInfoCard(context,
                    children: [
                      _buildInfoRow(context,
                        icon: Icons.cake_outlined,
                        label: 'Edad',
                        value: user?.ageRange ?? 'No especificado',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(context,
                        icon: Icons.people_outline,
                        label: 'Género',
                        value: user?.gender ?? 'No especificado',
                      ),
                    ],
                  ),
                  SizedBox(height: S.h(context, 0.04)),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.configuracion),
                      icon: const Icon(Icons.settings_outlined),
                      label: const Text('Configuración'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.of(context).primary,
                        side: BorderSide(color: AppColors.of(context).primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: S.h(context, 0.018)),
                      ),
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.015)),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(AppStrings.perfilLogoutConfirm),
                            content: const Text(
                                'Se cerrará tu sesión actual.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text(AppStrings.cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  await ref
                                      .read(authProvider.notifier)
                                      .logout();
                                  if (context.mounted) {
                                    context.go(AppRoutes.welcome);
                                  }
                                },
                                child: Text(
                                  AppStrings.perfilLogout,
                                  style: TextStyle(color: AppColors.of(context).error),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(AppStrings.perfilLogout),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.of(context).error,
                        side: BorderSide(color: AppColors.of(context).error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: S.h(context, 0.018)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.of(context).border),
      ),
      child: Padding(
        padding: EdgeInsets.all(S.w(context, 0.04)),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.of(context).primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: S.sp(context, 12),
                color: AppColors.of(context).textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: S.sp(context, 14),
                fontWeight: FontWeight.w500,
                color: AppColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
