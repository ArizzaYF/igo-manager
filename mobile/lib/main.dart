import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage.dart';
import 'data/datasources/supabase_client.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/iniciativas/create_iniciativa_screen.dart';
import 'presentation/screens/iniciativas/iniciativa_detail_screen.dart';
import 'presentation/screens/iniciativas/iniciativas_list_screen.dart';
import 'presentation/screens/matriz/matriz_igo_screen.dart';
import 'presentation/screens/onboarding/login_screen.dart';
import 'presentation/screens/onboarding/register_step1_screen.dart';
import 'presentation/screens/onboarding/register_step2_screen.dart';
import 'presentation/screens/onboarding/terms_screen.dart';
import 'presentation/screens/onboarding/welcome_screen.dart';
import 'presentation/screens/perfil/configuracion_screen.dart';
import 'presentation/screens/perfil/perfil_screen.dart';
import 'presentation/screens/planes/create_plan_screen.dart';
import 'presentation/screens/planes/plan_detail_screen.dart';
import 'presentation/screens/planes/planes_list_screen.dart';
import 'presentation/screens/priorizacion/igo_sliders_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/widgets/home_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseClientManager.init(
    SupabaseConfig(
      url: const String.fromEnvironment('SUPABASE_URL')
          .isEmpty
          ? 'https://qjawpuzvsiubkhurxrfr.supabase.co'
          : const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY')
          .isEmpty
          ? 'sb_publishable_zn8ukP6b-uUzkXR3IuiW0Q_p8MrUTRa'
          : const String.fromEnvironment('SUPABASE_ANON_KEY'),
    ),
  );

  await LocalStorage.getInstance();

  runApp(
    const ProviderScope(
      child: IgoManagerApp(),
    ),
  );
}

class IgoManagerApp extends ConsumerWidget {
  const IgoManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'IGO Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerStep1,
        builder: (context, state) => const RegisterStep1Screen(),
      ),
      GoRoute(
        path: AppRoutes.registerStep2,
        builder: (context, state) => const RegisterStep2Screen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (context, state) => const TermsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            SelectionArea(child: HomeShell(child: child)),
        routes: [
          GoRoute(
            path: AppRoutes.iniciativas,
            builder: (context, state) => const IniciativasListScreen(),
          ),
          GoRoute(
            path: AppRoutes.iniciativasCreate,
            builder: (context, state) => const CreateIniciativaScreen(),
          ),
          GoRoute(
            path: AppRoutes.iniciativaDetail,
            builder: (context, state) => IniciativaDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: AppRoutes.priorizacion,
            builder: (context, state) => IgoSlidersScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: AppRoutes.matriz,
            builder: (context, state) => const MatrizIgoScreen(),
          ),
          GoRoute(
            path: AppRoutes.planes,
            builder: (context, state) => const PlanesListScreen(),
          ),
          GoRoute(
            path: AppRoutes.planesCreate,
            builder: (context, state) => CreatePlanScreen(
              iniciativaId: state.pathParameters['iniciativaId']!,
            ),
          ),
          GoRoute(
            path: AppRoutes.planDetail,
            builder: (context, state) => PlanDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: AppRoutes.perfil,
            builder: (context, state) => const PerfilScreen(),
          ),
          GoRoute(
            path: AppRoutes.configuracion,
            builder: (context, state) => const ConfiguracionScreen(),
          ),
        ],
      ),
    ],
  );
});
