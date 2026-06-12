<div align="center">

# 🚀 IGO Manager

### Plataforma de Priorización Empresarial basada en la Metodología IGO

*Digitaliza el análisis **Importancia vs Gobernabilidad** para que los emprendedores tomen decisiones estratégicas más inteligentes*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.22+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-18-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://reactjs.org)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Vercel](https://img.shields.io/badge/Vercel-Deploy-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://igo-manager-admin.vercel.app)
[![TailwindCSS](https://img.shields.io/badge/Tailwind-CSS-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white)](https://tailwindcss.com)

<br/>

[![Estado](https://img.shields.io/badge/Estado-MVP%20Completo-brightgreen?style=flat-square)](https://github.com)
[![Plataforma](https://img.shields.io/badge/Plataforma-Android%20%7C%20Web-blue?style=flat-square)](https://github.com)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-yellow?style=flat-square)](LICENSE)
[![Cliente](https://img.shields.io/badge/Cliente-Dinámica%20del%20Oriente%20S.A.S.-orange?style=flat-square)](https://github.com)

<br/>

**🔗 Panel Administrativo en producción:** [igo-manager-admin.vercel.app](https://igo-manager-admin.vercel.app)

</div>

---

## 📋 Tabla de Contenidos

- [Sobre el Proyecto](#-sobre-el-proyecto)
- [Capturas de Pantalla](#-capturas-de-pantalla)
- [Arquitectura del Sistema](#-arquitectura-del-sistema)
- [Módulos Implementados](#-módulos-implementados)
- [Stack Tecnológico](#-stack-tecnológico)
- [Instalación y Ejecución](#-instalación-y-ejecución)
- [Variables de Entorno](#-variables-de-entorno)
- [Acceso Demo](#-acceso-demo)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Equipo](#-equipo)
- [Licencia](#-licencia)

---

## 🎯 Sobre el Proyecto

**IGO Manager** es una solución full-stack desarrollada para **Dinámica del Oriente S.A.S.** que permite a emprendedores y empresas digitalizar la metodología **IGO (Importancia vs Gobernabilidad)** — una herramienta de gestión estratégica que ayuda a priorizar iniciativas empresariales según dos ejes clave:

| Eje | Descripción |
|-----|-------------|
| **Importancia** | ¿Qué tan crítica es esta iniciativa para el negocio? (1–5) |
| **Gobernabilidad** | ¿Cuánto control tenemos sobre su ejecución? (1–5) |

### Objetivos Duales

```
┌─────────────────────────────────────┬──────────────────────────────────────┐
│  👤 Para el Emprendedor             │  🏢 Para Dinámica del Oriente        │
├─────────────────────────────────────┼──────────────────────────────────────┤
│  • Digitalizar sus iniciativas      │  • Analizar patrones del ecosistema  │
│  • Priorizar con criterio objetivo  │  • Visualizar la matriz IGO agregada │
│  • Crear planes de acción concretos │  • Demografía de emprendedores       │
│  • Seguir el progreso en tiempo     │  • Nube de palabras de iniciativas   │
│    real desde el móvil              │  • KPIs del portafolio en dashboard  │
└─────────────────────────────────────┴──────────────────────────────────────┘
```

---

## 📱 Capturas de Pantalla

### Módulo Mobile (Flutter)

| Pantalla | Descripción |
|----------|-------------|
| **Splash & Onboarding** | Auto-login con sesión persistida, registro en 2 pasos con validación en tiempo real |
| **Iniciativas** | Lista con filtros por cuadrante, tarjetas con indicador de prioridad, CRUD completo |
| **Motor IGO** | Sliders duales (Importancia / Gobernabilidad) con feedback visual del cuadrante resultante |
| **Matriz IGO** | `CustomPainter` interactivo con clustering por coordenadas, badges numéricos y modal de detalle |
| **Planes de Acción** | Creación de planes vinculados a iniciativas, gestión de tareas con responsable y progreso |
| **Perfil & Config** | Datos del usuario, cambio de contraseña, toggle de modo oscuro |
| **Speech-to-Text** | Dictado de título/descripción con waveform en tiempo real (30 barras animadas) |

### Panel Administrativo (React)

| Vista | Descripción |
|-------|-------------|
| **Dashboard** | KPIs globales (usuarios, iniciativas, planes), gráficos con polling cada 30 segundos |
| **Matriz Agregada** | ScatterPlot con clustering, tooltip custom (300ms delay anti-race condition), modal drill-down |
| **Nube de Palabras** | Word cloud interactivo con extracción client-side, ~200 stop words filtradas en español |
| **Demografía** | Distribución por sector, tamaño de empresa, edad y género de los emprendedores |

---

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        IGO Manager                              │
│                                                                 │
│   📱 App Mobile                    🖥️  Panel Admin              │
│   Flutter (Android/Web)            React + Vite                 │
│   ├── Riverpod (estado)            ├── TailwindCSS              │
│   ├── GoRouter (navegación)        ├── Recharts                 │
│   ├── fl_chart (gráficas)          ├── Supabase JS client       │
│   └── speech_to_text              └── Vercel (deploy)          │
│            │                                  │                 │
│            └──────────────┬───────────────────┘                 │
│                           ▼                                     │
│              ☁️  Supabase (BaaS)                                │
│              ├── PostgreSQL (base de datos)                     │
│              ├── Auth / Row Level Security                      │
│              ├── RPC Functions (register, change_password)      │
│              └── Realtime (polling 30s admin)                   │
└─────────────────────────────────────────────────────────────────┘
```

### Modelo de Datos Simplificado

```
app_users ──── profiles
    │               │
    │          initiatives ──── action_plans ──── tasks
    │               │
    └──────── notifications
```

---

## 🧩 Módulos Implementados

### 📲 App Mobile

#### 1. Onboarding
- Splash screen con auto-login (sesión en `shared_preferences`)
- Registro en 2 pasos: datos personales + datos de empresa
- Login con hash `crypt()` server-side vía RPC `register_app_user`
- Pantalla de términos y condiciones

#### 2. Gestión de Iniciativas
- CRUD completo (crear, listar, editar, archivar)
- Filtros por cuadrante (Atacar / Reforzar / Eliminar / Mantener)
- Dictado por voz con waveform animado en tiempo real
- Detalle con acceso directo a priorización y plan de acción

#### 3. Motor IGO (Priorización)
- Sliders 1–5 para **Importancia** y **Gobernabilidad**
- Badge de cuadrante con color y etiqueta en tiempo real
- Botón "Recalificar" para actualizar la priorización

#### 4. Matriz IGO Interactiva
- `CustomPainter` con ejes X=Gobernabilidad / Y=Importancia
- Clustering de puntos por coordenada con badge contador
- Tap en cluster → Bottom Sheet con lista de iniciativas
- Soporte modo oscuro (colores de grilla y ejes adaptativos)

#### 5. Plan de Acción
- Crear plan vinculado a iniciativa (1 plan por iniciativa)
- Gestión de tareas: agregar, completar (toggle), asignar responsable
- Barra de progreso verde persistida en Supabase
- Lista de planes con nombre de iniciativa (no UUID)

#### 6. Perfil y Configuración
- Datos del usuario con avatar
- Cambio de contraseña (validación: min 8 chars, mayúscula, número, carácter especial)
- Toggle modo oscuro (adaptativo en AppBar, BottomNav, Matriz y contenedores)

#### 7. Notificaciones *(infraestructura DB lista)*
- Tabla `notifications` en Supabase disponible
- Push notifications: pendiente de implementación Flutter

---

### 🖥️ Panel Administrativo

#### 8. Dashboard
- KPIs: total usuarios, iniciativas, planes, distribución por cuadrante
- Gráficos de barras y pie con **Recharts**
- Polling automático cada 30 segundos

#### 9. Matriz IGO Agregada
- ScatterPlot con clustering por coordenadas `(importancia, gobernabilidad)`
- Tooltip HTML custom (300ms delay para evitar race condition de Recharts)
- ClusterModal: lista detallada de iniciativas al hacer clic en un cluster
- Escala unificada: UI 1–5, DB 1–10 (multiplicación ×2 transparente)

#### 10. Nube de Palabras
- Extracción client-side: tokeniza títulos + descripciones
- Filtra ~200 stop words en español
- Tabla de frecuencias con las 20 palabras más usadas
- Word Cloud interactivo con hover/tooltip

#### 11. Demografía
- Distribución por sector empresarial
- Distribución por tamaño de empresa (Micro / Pequeña / Mediana)
- Datos de edad y género de emprendedores registrados

---

## 🛠️ Stack Tecnológico

### Mobile
| Tecnología | Versión | Uso |
|------------|---------|-----|
| Flutter | ≥ 3.22 | Framework principal |
| Dart | ≥ 3.2 | Lenguaje |
| flutter_riverpod | 2.x | Gestión de estado |
| go_router | 14.x | Navegación declarativa |
| supabase_flutter | 2.x | Backend / Auth |
| fl_chart | 0.69.x | Gráfica de matriz |
| speech_to_text | 7.4.0 | Dictado por voz |
| dartz | 0.10.x | Programación funcional (Either) |
| shared_preferences | 2.x | Sesión local |

### Admin
| Tecnología | Versión | Uso |
|------------|---------|-----|
| React | 18 | Framework UI |
| Vite | 5 | Bundler |
| TailwindCSS | 3 | Estilos utilitarios |
| Recharts | 2.x | Gráficos y ScatterPlot |
| @supabase/supabase-js | 2.x | Cliente Supabase |
| TypeScript | 5 | Tipado estático |

### Backend / Infraestructura
| Tecnología | Uso |
|------------|-----|
| **Supabase** (PostgreSQL) | Base de datos, Auth, RLS, RPC |
| **Vercel** | Deploy del panel admin |
| **GitHub** | Control de versiones |

---

## 🚀 Instalación y Ejecución

### Prerequisitos

```bash
# Mobile
flutter --version   # >= 3.22
dart --version      # >= 3.2

# Admin
node --version      # >= 18
pnpm --version      # >= 8  (recomendado) o npm >= 9
```

---

### 📱 Módulo Mobile (Flutter)

```bash
# 1. Clonar el repositorio
git clone <url-del-repo>
cd AplicacionEmpresa

# 2. Instalar dependencias
cd mobile
flutter pub get

# 3a. Ejecutar en navegador web
flutter run -d chrome

# 3b. Ejecutar en dispositivo Android (USB)
flutter devices               # verificar dispositivo conectado
flutter run -d <device-id>

# 4. Generar APK release
flutter build apk --release
# APK generado en: build/app/outputs/flutter-apk/app-release.apk
```

> **Nota:** La app se conecta automáticamente a Supabase. No requiere configuración adicional de variables de entorno en el cliente mobile.

**Comandos útiles:**
```bash
flutter analyze                          # análisis estático (0 errores)
flutter clean && flutter pub get         # limpiar y reinstalar dependencias
flutter build apk --release              # compilar APK para distribución
```

---

### 🖥️ Panel Administrativo (React)

> ⚠️ **Usar CMD** (no PowerShell) en Windows para evitar problemas con `pnpm`.

```bash
# 1. Ir a la carpeta admin
cd admin

# 2. Instalar dependencias
pnpm install
# o si no tienes pnpm:
npm install

# 3. Ejecutar en modo desarrollo
pnpm run dev
# o: npm run dev

# Abre: http://localhost:5173
```

**Build de producción:**
```bash
pnpm run build
# o: npx vite build
# Genera dist/ listo para deploy en Vercel
```

---

## 🔐 Variables de Entorno

El proyecto ya tiene las credenciales de Supabase embebidas para el ambiente de desarrollo/demo. Para un ambiente productivo propio, configurar:

### Admin (`admin/.env`)

```env
VITE_SUPABASE_URL=https://tu-proyecto.supabase.co
VITE_SUPABASE_ANON_KEY=tu-anon-key-publica
```

### Mobile (`mobile/lib/core/config/`)

Las credenciales están en `mobile/lib/main.dart` en `Supabase.initialize()`. Para producción propia:

```dart
await Supabase.initialize(
  url: 'https://tu-proyecto.supabase.co',
  anonKey: 'tu-anon-key-publica',
);
```

---

## 🔑 Acceso Demo

### Panel Administrativo

Accede a [igo-manager-admin.vercel.app](https://igo-manager-admin.vercel.app) con:

| Campo | Valor |
|-------|-------|
| **Correo** | `admin@dinamicadeloriente.com` |
| **Contraseña** | `Admin12345*` |

### App Mobile (usuarios demo)

Puedes registrar un usuario nuevo directamente en la app, o usar cualquier cuenta existente en el ambiente de demo de Supabase.

---

## 📁 Estructura del Proyecto

```
AplicacionEmpresa/
├── 📱 mobile/                    # App Flutter
│   ├── lib/
│   │   ├── core/
│   │   │   ├── constants/        # AppColors, AppStrings
│   │   │   ├── theme/            # AppTheme (light/dark)
│   │   │   └── utils/            # ResponsiveHelper (S.w, S.h, S.sp)
│   │   ├── data/
│   │   │   ├── models/           # UsuarioModel, IniciativaModel, PlanModel
│   │   │   └── repositories/     # AuthRepo, IniciativaRepo, PlanRepo
│   │   ├── domain/
│   │   │   └── usecases/         # Casos de uso (Clean Architecture)
│   │   └── presentation/
│   │       ├── providers/        # Riverpod providers
│   │       ├── screens/          # Pantallas por módulo
│   │       │   ├── onboarding/   # splash, welcome, login, register, terms
│   │       │   ├── iniciativas/  # list, detail, create
│   │       │   ├── priorizacion/ # igo_sliders
│   │       │   ├── matriz/       # matriz_igo_screen
│   │       │   ├── planes/       # list, detail, create
│   │       │   └── perfil/       # perfil, configuracion
│   │       └── widgets/          # Componentes reutilizables
│   ├── android/                  # Configuración Android (APK)
│   ├── web/                      # Configuración Web
│   └── pubspec.yaml
│
├── 🖥️  admin/                    # Panel React
│   └── src/
│       ├── api/                  # metricas.api.ts, iniciativas.api.ts
│       ├── components/           # ScatterPlot, WordCloud, CustomTooltip
│       ├── config/               # supabase.ts
│       ├── pages/                # Dashboard, MatrizAgregada, NubePalabras,
│       │                         # Demografía, Login
│       └── types/                # Tipos TypeScript
│
├── 📂 contexto_ia/               # SQL del schema y datos demo
│   ├── db_reconstruida.sql       # Schema completo + datos de ejemplo
│   └── db_alimentacion_extra.sql # RPCs (register_app_user, change_password)
│
└── README.md
```

---

## 👥 Equipo

<div align="center">

| Rol | Nombre |
|-----|--------|
| **Desarrollador Full Stack** | Jairo Andres Ariza Hernandez |
| **Desarrollador** | Julian Jaimes Reyes |
| **Desarrollador** | Julian Rene Vacca Ariza |
| **Cliente** | Dinámica del Oriente S.A.S. |

</div>

---

## 📄 Licencia

```
MIT License

Copyright (c) 2024 Jairo Andres Ariza Hernandez, Julian Jaimes Reyes, Julian Rene Vacca Ariza — Dinámica del Oriente S.A.S.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">

Desarrollado con ❤️ para **Dinámica del Oriente S.A.S.**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)](https://reactjs.org)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)](https://supabase.com)
[![Vercel](https://img.shields.io/badge/Vercel-000000?style=flat-square&logo=vercel&logoColor=white)](https://vercel.com)

</div>

