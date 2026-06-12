import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/constants/app_strings.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.termsTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(S.w(context, 0.06)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Aceptación de los Términos',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'Al utilizar la aplicación IGO Manager, usted acepta los presentes términos y condiciones en su totalidad. Si no está de acuerdo con alguno de estos términos, no debe utilizar la aplicación.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '2. Descripción del Servicio',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'IGO Manager es una herramienta de gestión empresarial que permite a los usuarios priorizar iniciativas utilizando la metodología IGO (Importancia vs Gobernabilidad). El servicio incluye la creación de iniciativas, su clasificación en la matriz IGO, y la generación de planes de acción asociados.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '3. Registro y Cuenta',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'Para utilizar la aplicación, debe registrar una cuenta proporcionando información veraz y completa. Usted es responsable de mantener la confidencialidad de sus credenciales de acceso y de todas las actividades que ocurran bajo su cuenta.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '4. Propiedad Intelectual',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'Todos los derechos de propiedad intelectual de la aplicación IGO Manager, incluyendo su código fuente, diseño, logotipos y contenido, pertenecen a sus creadores. El usuario no adquiere ningún derecho sobre estos elementos.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '5. Privacidad de Datos',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'La información personal proporcionada será utilizada exclusivamente para los fines de la aplicación. No compartiremos sus datos personales con terceros sin su consentimiento explícito, excepto cuando sea requerido por ley.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '6. Limitación de Responsabilidad',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'IGO Manager es una herramienta de apoyo a la toma de decisiones. Las decisiones finales basadas en la información proporcionada por la aplicación son responsabilidad exclusiva del usuario. No nos hacemos responsables por pérdidas o daños derivados del uso de la aplicación.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '7. Modificaciones',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Los cambios serán notificados a través de la aplicación. El uso continuado de la aplicación después de dichas modificaciones constituye la aceptación de los nuevos términos.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.025)),
                  Text(
                    '8. Contacto',
                    style: TextStyle(
                      fontSize: S.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.01)),
                  Text(
                    'Para cualquier consulta relacionada con estos términos, puede contactarnos a través de los medios dispuestos en la aplicación.',
                    style: TextStyle(
                      fontSize: S.sp(context, 14),
                      color: AppColors.of(context).textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: S.h(context, 0.04)),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(S.w(context, 0.04)),
            decoration: BoxDecoration(
              color: AppColors.of(context).surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: S.h(context, 0.06),
                    child: OutlinedButton(
                      onPressed: () => context.pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Rechazar'),
                    ),
                  ),
                ),
                SizedBox(width: S.w(context, 0.04)),
                Expanded(
                  child: SizedBox(
                    height: S.h(context, 0.06),
                    child: ElevatedButton(
                      onPressed: () => context.pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(AppStrings.termsAccept),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
