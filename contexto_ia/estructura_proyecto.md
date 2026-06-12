# IGO Manager — Estructura Completa del Proyecto

**Cliente:** Dinámica del Oriente S.A.S.
**Stack:** Flutter (Mobile) · Supabase (Backend) · React (Panel Admin)
**Versión:** 1.0 — MVP

---

## Stack Tecnológico Definitivo

| Capa | Tecnología | Justificación |
|---|---|---|
| App Móvil | Flutter 3.x | Un solo código → iOS + Android |
| Backend / DB | Supabase (PostgreSQL) | Auth, Realtime, Storage, Push integrado |
| Panel Admin | React 18 + Vite | Web responsivo, rápido de desarrollar |
| Notificaciones | Firebase Cloud Messaging (FCM) | Estándar de industria para push |
| Speech-to-Text | Google Cloud STT (o Whisper API) | Feature deseable del Módulo 2 |
| Storage (audio) | Supabase Storage | Almacén de archivos de voz |
| Hosting Admin | Vercel o Netlify | Deploy automático desde Git |

---

## Árbol de Directorios

```
igo_manager/
│
├── README.md
├── .gitignore
├── .env.example
│
├── docs/                          # Documentación del proyecto
│   ├── DRF_v1.0.pdf               # Documento de requerimientos original
│   ├── arquitectura.md            # Diagrama de arquitectura
│   └── api_endpoints.md           # Referencia de endpoints (auto-gen desde Supabase)
│
├── database/                      # Scripts de base de datos
│   ├── igo_manager_database.sql   # Script principal (schema completo)
│   ├── migrations/                # Cambios futuros al schema
│   │   └── 001_initial.sql        # Primera migración
│   └── seeds/
│       └── admin_seed.sql         # Datos iniciales (usuario admin)
│
├── mobile/                        # App Flutter
│   ├── pubspec.yaml
│   ├── pubspec.lock
│   ├── analysis_options.yaml
│   ├── android/                   # Config Android (Play Store)
│   │   ├── app/
│   │   │   ├── build.gradle
│   │   │   └── google-services.json   # Config FCM Android
│   │   └── build.gradle
│   ├── ios/                       # Config iOS (App Store)
│   │   ├── Runner/
│   │   │   ├── AppDelegate.swift
│   │   │   ├── GoogleService-Info.plist  # Config FCM iOS
│   │   │   └── Info.plist
│   │   └── Podfile
│   │
│   └── lib/
│       ├── main.dart              # Punto de entrada
│       │
│       ├── core/                  # Configuración global
│       │   ├── constants/
│       │   │   ├── app_colors.dart        # Colores corporativos Dinámica del Oriente
│       │   │   ├── app_strings.dart       # Textos / i18n
│       │   │   └── app_routes.dart        # Rutas nombradas
│       │   ├── theme/
│       │   │   ├── app_theme.dart         # ThemeData claro
│       │   │   └── app_theme_dark.dart    # ThemeData oscuro
│       │   ├── errors/
│       │   │   ├── exceptions.dart
│       │   │   └── failures.dart
│       │   └── utils/
│       │       ├── validators.dart        # Validación de formularios
│       │       └── igo_calculator.dart    # Lógica de cuadrante IGO
│       │
│       ├── data/                  # Capa de datos
│       │   ├── models/
│       │   │   ├── usuario_model.dart
│       │   │   ├── iniciativa_model.dart
│       │   │   ├── plan_accion_model.dart
│       │   │   └── alerta_model.dart
│       │   ├── repositories/
│       │   │   ├── auth_repository.dart
│       │   │   ├── usuario_repository.dart
│       │   │   ├── iniciativa_repository.dart
│       │   │   └── plan_repository.dart
│       │   └── datasources/
│       │       ├── supabase_client.dart   # Configuración Supabase
│       │       └── local_storage.dart     # Caché offline (Hive/SharedPrefs)
│       │
│       ├── domain/                # Lógica de negocio (Clean Architecture)
│       │   ├── entities/
│       │   │   ├── usuario.dart
│       │   │   ├── iniciativa.dart
│       │   │   └── plan_accion.dart
│       │   └── usecases/
│       │       ├── auth/
│       │       │   ├── login_usecase.dart
│       │       │   ├── register_usecase.dart
│       │       │   └── logout_usecase.dart
│       │       ├── iniciativas/
│       │       │   ├── crear_iniciativa_usecase.dart
│       │       │   ├── listar_iniciativas_usecase.dart
│       │       │   ├── calificar_igo_usecase.dart
│       │       │   └── archivar_iniciativa_usecase.dart
│       │       └── planes/
│       │           ├── crear_plan_usecase.dart
│       │           └── actualizar_estado_plan_usecase.dart
│       │
│       └── presentation/          # UI (Screens + Widgets + State)
│           ├── providers/         # Riverpod / BLoC providers
│           │   ├── auth_provider.dart
│           │   ├── iniciativas_provider.dart
│           │   └── planes_provider.dart
│           │
│           ├── screens/
│           │   │
│           │   ├── splash/
│           │   │   └── splash_screen.dart
│           │   │
│           │   ├── onboarding/            # MÓDULO 1
│           │   │   ├── welcome_screen.dart
│           │   │   ├── register_step1_screen.dart   # Datos personales
│           │   │   ├── register_step2_screen.dart   # Perfil empresarial
│           │   │   ├── login_screen.dart
│           │   │   └── terms_screen.dart
│           │   │
│           │   ├── iniciativas/           # MÓDULO 2
│           │   │   ├── iniciativas_list_screen.dart  # Home
│           │   │   ├── create_iniciativa_screen.dart
│           │   │   └── iniciativa_detail_screen.dart
│           │   │
│           │   ├── priorizacion/          # MÓDULO 3
│           │   │   └── igo_sliders_screen.dart
│           │   │
│           │   ├── matriz/                # MÓDULO 4
│           │   │   └── matriz_igo_screen.dart
│           │   │
│           │   ├── planes/                # MÓDULO 5
│           │   │   ├── planes_list_screen.dart
│           │   │   ├── create_plan_screen.dart
│           │   │   └── plan_detail_screen.dart
│           │   │
│           │   └── perfil/
│           │       ├── perfil_screen.dart
│           │       └── configuracion_screen.dart
│           │
│           └── widgets/           # Componentes reutilizables
│               ├── igo_matrix_widget.dart     # Gráfico de cuadrantes interactivo
│               ├── igo_sliders_widget.dart    # Sliders + preview cartesiano
│               ├── progress_bar_widget.dart   # Barra progreso planes
│               ├── iniciativa_card.dart
│               ├── plan_card.dart
│               ├── cuadrante_badge.dart       # Etiqueta del cuadrante (chip)
│               └── audio_recorder_widget.dart # Botón micrófono STT
│
├── admin/                         # Panel Web React (Módulo 7)
│   ├── package.json
│   ├── vite.config.ts
│   ├── tsconfig.json
│   ├── index.html
│   └── src/
│       ├── main.tsx
│       ├── App.tsx
│       ├── router.tsx             # React Router v6
│       │
│       ├── config/
│       │   └── supabase.ts        # Cliente Supabase para admin
│       │
│       ├── types/
│       │   └── index.ts           # Tipos TypeScript globales
│       │
│       ├── api/                   # Llamadas a Supabase/PostgreSQL
│       │   ├── metricas.api.ts
│       │   ├── usuarios.api.ts
│       │   └── iniciativas.api.ts
│       │
│       ├── pages/
│       │   ├── Login.tsx                  # Autenticación admin
│       │   ├── Dashboard.tsx              # Vista principal KPIs
│       │   ├── Demografia.tsx             # Gráficas de torta
│       │   ├── MatrizAgregada.tsx         # Matriz IGO de todos los usuarios
│       │   └── NubePalabras.tsx           # Word cloud / mapa de calor
│       │
│       └── components/
│           ├── KpiCard.tsx
│           ├── PieChart.tsx               # Recharts
│           ├── ScatterPlot.tsx            # Recharts - Matriz IGO
│           ├── WordCloud.tsx              # react-wordcloud
│           ├── UsuariosMesChart.tsx       # Línea de crecimiento
│           └── Sidebar.tsx
│
└── backend/                       # Jobs y funciones serverless
    ├── jobs/
    │   ├── alertas_worker.ts      # Procesa v_alertas_pendientes y envía por FCM
    │   ├── palabras_clave_job.ts  # Llama a calcular_palabras_clave_diarias()
    │   └── snapshot_metrics_job.ts  # Llena metricas_admin_snapshot diariamente
    └── functions/                 # Supabase Edge Functions
        ├── send-push/
        │   └── index.ts           # Envía notificación FCM desde el servidor
        └── speech-to-text/
            └── index.ts           # Proxy a Google STT / Whisper API
```

---

## Dependencias Flutter (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Backend
  supabase_flutter: ^2.x

  # State Management
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x

  # Navegación
  go_router: ^13.x

  # UI & Gráficos
  fl_chart: ^0.68.x          # Matriz IGO (ScatterChart)
  syncfusion_flutter_sliders: ^24.x  # Sliders IGO

  # Audio / STT
  record: ^5.x               # Grabación de audio
  permission_handler: ^11.x  # Permisos micrófono

  # Notificaciones Push
  firebase_core: ^2.x
  firebase_messaging: ^14.x
  flutter_local_notifications: ^17.x

  # Almacenamiento local
  hive_flutter: ^1.x
  shared_preferences: ^2.x

  # Utilidades
  intl: ^0.19.x              # Formato de fechas
  uuid: ^4.x
  equatable: ^2.x
  dartz: ^0.10.x             # Either para manejo de errores

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.x
  build_runner: ^2.x
  flutter_lints: ^3.x
  mockito: ^5.x
```

---

## Dependencias React Admin (package.json)

```json
{
  "dependencies": {
    "react": "^18.x",
    "react-dom": "^18.x",
    "react-router-dom": "^6.x",
    "@supabase/supabase-js": "^2.x",
    "recharts": "^2.x",
    "react-wordcloud": "^1.x",
    "axios": "^1.x",
    "date-fns": "^3.x",
    "tailwindcss": "^3.x",
    "lucide-react": "^0.x"
  },
  "devDependencies": {
    "typescript": "^5.x",
    "vite": "^5.x",
    "@vitejs/plugin-react": "^4.x"
  }
}
```

---

## Variables de Entorno (.env.example)

```bash
# Supabase
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...   # Solo para jobs del backend

# Firebase (para jobs backend)
FCM_SERVER_KEY=AAAA...
FIREBASE_PROJECT_ID=igo-manager

# Speech-to-Text (Feature Deseable)
GOOGLE_CLOUD_STT_API_KEY=AIza...
# O alternativamente:
OPENAI_WHISPER_API_KEY=sk-...

# Admin Panel
VITE_SUPABASE_URL=https://xxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
ADMIN_SECRET_PASSWORD=...
```

---

## Módulos → Pantallas → Tablas BD

| Módulo | Pantallas Flutter | Tablas PostgreSQL |
|---|---|---|
| M1 — Onboarding | welcome, register_step1, register_step2, login, terms | `usuarios`, `autenticacion`, `sesiones`, `configuracion_usuario` |
| M2 — Iniciativas | iniciativas_list, create_iniciativa, iniciativa_detail | `iniciativas` |
| M3 — Motor IGO | igo_sliders | `iniciativas` (importancia, gobernabilidad, cuadrante) |
| M4 — Matriz | matriz_igo | `iniciativas` (lectura agregada) |
| M5 — Plan Acción | planes_list, create_plan, plan_detail | `planes_accion`, `aliados_responsables`, `historial_estados_plan` |
| M6 — Alertas | (background service) | `alertas`, `tokens_push` |
| M7 — Admin Web | Dashboard, Demografía, MatrizAgregada, NubePalabras | `metricas_admin_snapshot`, `palabras_clave_iniciativas`, `matriz_igo_agregada`, `v_demografia_usuarios`, `v_igo_por_sector` |

---

## Orden de Desarrollo Recomendado (Sprints)

### Sprint 1 — Fundamentos (2 semanas)
- Setup repo + Supabase + Firebase
- Ejecutar `igo_manager_database.sql`
- Módulo 1: Onboarding completo (registro + login + habeas data)

### Sprint 2 — Core IGO (2 semanas)
- Módulo 2: Gestión de iniciativas (CRUD)
- Módulo 3: Sliders + cálculo cuadrante
- Módulo 4: Visualización matriz interactiva

### Sprint 3 — Planes y Alertas (2 semanas)
- Módulo 5: Plan de acción + estados
- Módulo 6: Notificaciones push + jobs de alertas

### Sprint 4 — Admin Web (1.5 semanas)
- Módulo 7: Panel administrativo completo
- Jobs nocturnos: snapshots + palabras clave

### Sprint 5 — Pulido MVP (1 semana)
- Modo oscuro
- Pruebas en dispositivos físicos
- Preparación APK/AAB para Play Store + IPA para TestFlight

**Total estimado: ~8.5 semanas para MVP funcional**

---

## Entregables del Desarrollador

1. **Código Fuente** — Repositorio privado GitHub/GitLab con ramas `main` + `develop`
2. **APK / AAB** — Android listo para Play Store
3. **IPA** — iOS listo para TestFlight / App Store
4. **Panel Admin** — URL en producción (Vercel/Netlify)
5. **Manual de Despliegue** — Instrucciones para Supabase, Firebase, variables de entorno
6. **Script BD** — `igo_manager_database.sql` versionado

---

*Documento generado para Dinámica del Oriente S.A.S. — IGO Manager v1.0*
