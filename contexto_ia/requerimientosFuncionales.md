# Documento de Requerimientos Funcionales (DRF)

**Nombre del Proyecto:** App Móvil "IGO Manager" (Nombre provisional)

**Cliente:** Dinámica del Oriente S.A.S.

**Versión:** 1.0

**Fecha:** 14 de Febrero, 2026

---

## 1. Resumen Ejecutivo

El proyecto consiste en el desarrollo de una aplicación móvil (iOS y Android) orientada a emprendedores y empresarios. La App digitaliza la metodología de consultoría **IGO (Importancia vs. Gobernabilidad)**.

**Objetivos Duales:**

1. **Para el Usuario:** Permitir el registro de ideas/proyectos, priorizarlos mediante un algoritmo visual de cuadrantes y gestionar un plan de acción con alertas.
2. **Para el Cliente (Administrador):** Recopilar "Data de Primera Fuente" sobre las prioridades, sectores y dolores del tejido empresarial para inteligencia de negocios.

---

## 2. Perfiles de Usuario

- **Emprendedor (Usuario Final):** Persona que descarga la app para gestionar sus proyectos.
- **Administrador (SuperAdmin):** Personal de Dinámica del Oriente con acceso al Panel Web de Control para ver estadísticas y métricas globales (sin acceder a datos sensibles específicos que violen la privacidad).

---

## 3. Historias de Usuario y Módulos Funcionales

### Módulo 1: Onboarding y Registro (Captura de Data)

**Objetivo:** Crear el perfil del usuario y segmentarlo para el análisis posterior.

- **Login Social:** Opción de registro rápido con Google/Apple (Opcional pero recomendado).
- **Formulario de Perfilamiento (Obligatorio, única vez):**
  - *Nombre del Emprendedor* (Texto).
  - *Nombre de la Empresa / Idea* (Texto).
  - *Correo Electrónico* (Validación de formato).
  - *Celular* (Numérico).
  - *Sector Económico* (Lista Desplegable: Agro, Calzado/Moda, Tecnología, Servicios, Comercio, Salud, Turismo, Educación, Otro).
  - *Tamaño de Empresa* (Lista Desplegable: Idea, Micro <10, Pequeña <50, Mediana <200, Grande).
  - *Rango de Edad* (Lista Desplegable: 18-25, 26-35, 36-45, 46-55, +56).
  - *Género* (Lista Desplegable: Masculino, Femenino, Otro).
- **Términos y Condiciones:** Checkbox obligatorio de aceptación de política de tratamiento de datos (Habeas Data).

### Módulo 2: Gestión de Iniciativas (Input)

**Objetivo:** "Descarga mental" rápida de tareas o ideas.

- **Listado General:** Vista de todas las iniciativas registradas.
- **Crear Nueva Iniciativa:**
  - *Título:* (Ej: "Abrir sucursal en Bogotá").
  - *Descripción:* (Texto breve).
  - *Input de Audio (Feature Deseable):* Botón para grabar nota de voz que se transcribe a texto (Speech-to-Text) para el campo descripción.

### Módulo 3: Motor de Priorización IGO (Core)

**Objetivo:** Calificar cada iniciativa en dos ejes.

- **Interfaz de Calificación:** Al crear o editar una iniciativa, se presentan dos deslizadores (Sliders) del 1 al 10.
  - **Slider 1 - Importancia (Eje Y):** "Impacto futuro en crecimiento/transformación". (1 = Bajo Impacto, 10 = Alto Impacto).
  - **Slider 2 - Gobernabilidad (Eje X):** "Facilidad/Control actual de ejecución". (1 = Difícil/Externo, 10 = Fácil/Control Total).
- **Feedback Visual:** Mientras el usuario mueve los sliders, un punto se mueve en tiempo real sobre un gráfico de plano cartesiano pequeño en la pantalla.

### Módulo 4: Visualización de Cuadrantes (Output)

**Objetivo:** Mostrar gráficamente dónde caen las ideas y sugerir acciones.

- **Matriz Interactiva:** Gráfico de 4 cuadrantes donde cada punto es una iniciativa. Al tocar un punto, se abre el detalle.
- **Lógica de Clasificación:**
  - **Cuadrante I (Alta Imp / Alta Gob):** *Etiqueta:* "¡HACER YA!". *Acción:* Botón directo a "Crear Plan".
  - **Cuadrante II (Alta Imp / Baja Gob):** *Etiqueta:* "ESTRATÉGICO/ALIADOS". *Acción:* Sugerir buscar aliados/recursos.
  - **Cuadrante III (Baja Imp / Alta Gob):** *Etiqueta:* "RUTINA". *Acción:* Sugerir Delegar.
  - **Cuadrante IV (Baja Imp / Baja Gob):** *Etiqueta:* "DESCARTE". *Acción:* Sugerir Eliminar/Archivar.

### Módulo 5: Plan de Acción y Ejecución

**Objetivo:** Operativizar las tareas prioritarias (Cuadrantes I y II).

- **Conversión:** Solo las tareas seleccionadas pasan a esta vista.
- **Campos del Plan:**
  - *Fecha Límite (Deadline):* Selector de fecha.
  - *Presupuesto Estimado:* Campo numérico (Opcional).
  - *Aliados/Responsables:* Campo de texto o etiquetas.
  - *Estado:* Pendiente / En Proceso / Terminado / Abortado.
- **Barra de Progreso:** Visualización del % de avance global de los planes activos.

### Módulo 6: Sistema de Alertas (Notificaciones Push)

**Objetivo:** Recordación y engagement.

- **Alertas de Vencimiento:** Notificación 24 horas y 1 hora antes de la fecha límite.
- **Alertas de Inactividad:** "Hace 7 días no revisas tus prioridades".
- **Resumen Semanal:** Notificación local con el conteo de tareas completadas.

### Módulo 7: Panel Administrativo Web (Dashboard para Dinámica del Oriente)

**Objetivo:** Inteligencia de Negocios.

- **Acceso Web:** URL segura para el administrador.
- **Métricas Clave (KPIs):**
  - Usuarios registrados (Total y por mes).
  - Desglose demográfico (Gráficas de torta por Sector, Tamaño, Edad).
- **Mapa de Calor de Intereses:**
  - Nube de palabras o listado de los términos más frecuentes en los "Títulos" de las iniciativas de Alta Importancia (Anónimo). *Ej: Si muchos escriben "Exportar", el sistema lo destaca.*
  - Matriz IGO Agregada: Ver dónde se concentra el promedio de las iniciativas de todos los usuarios.

---

## 4. Requerimientos No Funcionales (Técnicos)

1. **Tecnología Recomendada:**
   - **Frontend (App):** Flutter (Google) - Para exportar a iOS y Android con un solo código base.
   - **Backend:** Firebase (Google) o Supabase. Ideal para manejo de usuarios, base de datos en tiempo real y notificaciones push.
   - **Panel Admin:** React o Flutter Web.

2. **Seguridad y Datos:**
   - Encriptación de contraseñas.
   - Cumplimiento de normativa de Habeas Data (Colombia). La base de datos debe permitir la anonimización de las iniciativas para el análisis estadístico del admin.

3. **Diseño (UI/UX):**
   - Estilo minimalista, corporativo pero moderno.
   - Modo Claro / Modo Oscuro.
   - Uso de los colores corporativos de Dinámica del Oriente.

---

## 5. Entregables Esperados del Desarrollador

1. **Código Fuente:** Repositorio en GitHub/GitLab.
2. **APK / AAB (Android):** Archivos listos para subir a Play Store.
3. **IPA (iOS):** Archivo listo para TestFlight / App Store.
4. **Manual de Despliegue:** Instrucciones para acceder al Panel Administrativo.

---

## Descripción de las Pantallas en la Imagen (De izquierda a derecha, arriba hacia abajo)

1. **Pantalla de Bienvenida:** El punto de entrada con tu logo, una frase motivadora y las opciones claras para "Comenzar Registro" o "Iniciar Sesión".
2. **Registro Paso 1 (Datos Personales):** Captura rápida de nombre, correo, teléfono y contraseña.
3. **Registro Paso 2 (Perfil Empresarial):** El paso clave donde el usuario selecciona su sector, tamaño de empresa, edad y género. Nota los campos tipo lista desplegable.
4. **Pantalla Principal (Mis Iniciativas):** El "Home" de la app, donde se listan las ideas con su estado y un botón flotante "+" para crear una nueva.
5. **Crear Nueva Iniciativa:** El formulario simple para capturar el título, descripción y, como puedes ver, un botón de micrófono para notas de voz.
6. **Motor de Priorización (Sliders IGO):** Los dos deslizadores para calificar "Importancia" y "Gobernabilidad" del 1 al 10, con una pequeña vista previa de dónde caerá el punto.
7. **Resultado en la Matriz IGO:** La visualización final de los 4 cuadrantes con sus nombres (Hacer Ya, Estratégico, Rutina, Descarte) y la acción sugerida "Crear Plan de Acción".
8. **Crear Plan de Acción:** El formulario para convertir una idea prioritaria en un plan con fecha límite, presupuesto y aliados.
9. **Alerta Push (Notificación):** Un ejemplo de cómo se vería un recordatorio en el celular del usuario.
10. **Panel Administrativo Web (Dashboard):** La vista de escritorio para ti, con gráficas de métricas clave (usuarios, sectores) y el mapa de calor de palabras clave.
