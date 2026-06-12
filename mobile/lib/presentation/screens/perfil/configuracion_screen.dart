import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/data/datasources/supabase_client.dart';
import 'package:igo_manager/data/datasources/local_storage.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';
import 'package:igo_manager/presentation/providers/theme_provider.dart';

class ConfiguracionScreen extends ConsumerStatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  ConsumerState<ConfiguracionScreen> createState() =>
      _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends ConsumerState<ConfiguracionScreen> {
  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Cambiar contraseña'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña actual',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  SizedBox(height: S.h(context, 0.015)),
                  TextFormField(
                    controller: newCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nueva contraseña',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      if (v.length < 8) return 'Mínimo 8 caracteres';
                      if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Debe tener mayúscula';
                      if (!RegExp(r'[0-9]').hasMatch(v)) return 'Debe tener número';
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) return 'Debe tener carácter especial';
                      return null;
                    },
                  ),
                  SizedBox(height: S.h(context, 0.015)),
                  TextFormField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar nueva contraseña',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) =>
                        v != newCtrl.text ? 'No coincide' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: isSaving ? null : () async {
                if (!formKey.currentState!.validate()) return;
                setDialogState(() => isSaving = true);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  final session = LocalStorage.instance.getUserSession();
                  final userId = session?['id'] as String?;
                  if (userId == null) throw Exception('Sesión no encontrada');
                  await SupabaseClientManager.client.rpc(
                    'change_password_app_user',
                    params: {
                      'p_user_id': userId,
                      'p_current_password': currentCtrl.text,
                      'p_new_password': newCtrl.text,
                    },
                  );
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Contraseña actualizada exitosamente'),
                      backgroundColor: AppColors.of(context).success,
                    ),
                  );
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.of(context).error,
                    ),
                  );
                }
              },
              child: isSaving
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.configTitle),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: S.h(context, 0.02)),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.06), vertical: S.h(context, 0.01)),
            child: Text(
              'APARIENCIA',
              style: TextStyle(
                  fontSize: S.sp(context, 12),
                  fontWeight: FontWeight.w600,
                color: AppColors.of(context).textSecondary,
                letterSpacing: 1,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text(AppStrings.configTheme),
            subtitle: const Text('Activar modo oscuro'),
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.of(context).primary,
            ),
            value: isDark,
            onChanged: (v) {
              ref.read(themeModeProvider.notifier).toggle();
            },
            activeTrackColor: AppColors.of(context).primary,
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.06), vertical: S.h(context, 0.01)),
            child: Text(
              'SEGURIDAD',
              style: TextStyle(
                  fontSize: S.sp(context, 12),
                  fontWeight: FontWeight.w600,
                color: AppColors.of(context).textSecondary,
                letterSpacing: 1,
              ),
            ),
          ),
          ListTile(
            leading:
                Icon(Icons.lock_outline, color: AppColors.of(context).primary),
            title: const Text('Cambiar contraseña'),
            subtitle: const Text('Actualiza tu contraseña actual'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: S.w(context, 0.06), vertical: S.h(context, 0.01)),
            child: Text(
              'INFORMACIÓN',
              style: TextStyle(
                  fontSize: S.sp(context, 12),
                  fontWeight: FontWeight.w600,
                color: AppColors.of(context).textSecondary,
                letterSpacing: 1,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.of(context).primary),
            title: const Text('Acerca de'),
            subtitle: const Text('IGO Manager v1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '1.0.0',
                applicationLegalese:
                    '© 2026 IGO Manager. Todos los derechos reservados.',
                children: [
                  SizedBox(height: S.h(context, 0.02)),
                  Text(
                    AppStrings.tagline,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description_outlined,
                color: AppColors.of(context).primary),
            title: const Text('Términos y condiciones'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Funcionalidad próximamente disponible')),
              );
            },
          ),
          ListTile(
            leading:
                Icon(Icons.privacy_tip_outlined, color: AppColors.of(context).primary),
            title: const Text('Política de privacidad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Funcionalidad próximamente disponible')),
              );
            },
          ),
          const Divider(height: 1),
          SizedBox(height: S.h(context, 0.04)),
          Center(
            child: Text(
              'IGO Manager v1.0.0',
              style: TextStyle(
                fontSize: S.sp(context, 12),
                color: AppColors.of(context).textHint.withValues(alpha: 0.7),
              ),
            ),
          ),
          SizedBox(height: S.h(context, 0.01)),
        ],
      ),
    );
  }
}
