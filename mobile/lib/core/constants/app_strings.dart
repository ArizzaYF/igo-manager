class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'IGO Manager';
  static const String tagline = 'Prioriza lo que realmente importa';

  // Onboarding
  static const String welcomeTitle = 'Bienvenido a IGO Manager';
  static const String welcomeSubtitle =
      'La herramienta que te ayuda a priorizar tus iniciativas empresariales usando la metodología IGO.';
  static const String welcomeRegister = 'Crear cuenta';
  static const String welcomeLogin = 'Ya tengo cuenta';

  // Register Step 1
  static const String registerTitle = 'Crear cuenta';
  static const String registerSubtitle = 'Completa tus datos básicos';
  static const String registerEmail = 'Correo electrónico';
  static const String registerPassword = 'Contraseña';
  static const String registerConfirmPassword = 'Confirmar contraseña';
  static const String registerFullName = 'Nombre completo';
  static const String registerPhone = 'Teléfono';
  static const String registerNext = 'Siguiente';
  static const String registerEmailHint = 'ejemplo@correo.com';
  static const String registerPasswordHint = 'Mín. 8 caracteres';

  // Register Step 2
  static const String registerCompany = 'Nombre de la empresa';
  static const String registerSector = 'Sector';
  static const String registerCompanySize = 'Tamaño de la empresa';
  static const String registerAgeRange = 'Rango de edad';
  static const String registerGender = 'Género';
  static const String registerAcceptTerms = 'Acepto los términos y condiciones';
  static const String registerFinish = 'Finalizar';
  static const String registerSuccess = 'Cuenta creada exitosamente';

  // Login
  static const String loginTitle = 'Iniciar sesión';
  static const String loginEmail = 'Correo electrónico';
  static const String loginPassword = 'Contraseña';
  static const String loginButton = 'Ingresar';
  static const String loginForgotPassword = '¿Olvidaste tu contraseña?';
  static const String loginNoAccount = '¿No tienes cuenta?';
  static const String loginLoading = 'Iniciando sesión...';

  // Terms
  static const String termsTitle = 'Términos y condiciones';
  static const String termsAccept = 'Aceptar';

  // Iniciativas (Initiatives)
  static const String iniciativasTitle = 'Mis Iniciativas';
  static const String iniciativasCreate = 'Nueva iniciativa';
  static const String iniciativasEmpty = 'Aún no tienes iniciativas. ¡Crea la primera!';
  static const String iniciativasDeleteConfirm = '¿Estás seguro de eliminar esta iniciativa?';
  static const String iniciativasArchived = 'Archivadas';
  static const String iniciativasActive = 'Activas';

  static const String iniciativaCreateTitle = 'Crear iniciativa';
  static const String iniciativaEditTitle = 'Editar iniciativa';
  static const String iniciativaDetailTitle = 'Detalle de iniciativa';
  static const String iniciativaFormTitle = 'Título';
  static const String iniciativaFormDescription = 'Descripción';
  static const String iniciativaFormAudio = 'Grabar audio';
  static const String iniciativaFormImportance = 'Importancia';
  static const String iniciativaFormGovernability = 'Gobernabilidad';
  static const String iniciativaFormSave = 'Guardar iniciativa';
  static const String iniciativaFormCancel = 'Cancelar';

  // IGO
  static const String igoTitle = 'Priorización IGO';
  static const String igoImportance = 'Importancia';
  static const String igoGovernability = 'Gobernabilidad';
  static const String igoSliderHint = 'Arrastra para asignar un valor';
  static const String igoCalculate = 'Calcular cuadrante';
  static const String igoResult = 'Resultado';
  static const String igoMatrizTitle = 'Matriz IGO';

  static const String hacerYa = 'Hacer ya';
  static const String estrategico = 'Estratégico / Alianzas';
  static const String rutina = 'Rutina';
  static const String descarte = 'Descarte';

  static const String hacerYaDesc = 'Alta importancia y alta gobernabilidad. Ejecuta de inmediato.';
  static const String estrategicoDesc =
      'Alta importancia pero baja gobernabilidad. Busca aliados estratégicos.';
  static const String rutinaDesc = 'Baja importancia pero alta gobernabilidad. Delegar o programar.';
  static const String descarteDesc = 'Baja importancia y baja gobernabilidad. Eliminar o posponer.';

  // Planes (Action Plans)
  static const String planesTitle = 'Planes de acción';
  static const String planesCreate = 'Crear plan';
  static const String planesEmpty = 'No hay planes de acción asociados.';
  static const String planesDeadline = 'Fecha límite';
  static const String planesBudget = 'Presupuesto estimado';
  static const String planesAllies = 'Aliados estratégicos';
  static const String planesResponsible = 'Responsable';
  static const String planesAddAlly = 'Agregar aliado';
  static const String planesTasks = 'Tareas';

  static const String planStatusPendiente = 'Pendiente';
  static const String planStatusEnProgreso = 'En progreso';
  static const String planStatusCompletado = 'Completado';
  static const String planStatusCancelado = 'Cancelado';

  static const String taskCreate = 'Agregar tarea';
  static const String taskTitle = 'Título de la tarea';
  static const String taskDescription = 'Descripción';
  static const String taskResponsible = 'Responsable';
  static const String taskDueDate = 'Fecha de vencimiento';
  static const String taskBudget = 'Presupuesto';

  // Perfil (Profile)
  static const String perfilTitle = 'Mi Perfil';
  static const String perfilEdit = 'Editar perfil';
  static const String perfilLogout = 'Cerrar sesión';
  static const String perfilLogoutConfirm = '¿Estás seguro de cerrar sesión?';

  // Configuración
  static const String configTitle = 'Configuración';
  static const String configNotifications = 'Notificaciones';
  static const String configTheme = 'Tema oscuro';
  static const String configLanguage = 'Idioma';
  static const String configVersion = 'Versión';

  // General
  static const String loading = 'Cargando...';
  static const String saving = 'Guardando...';
  static const String error = 'Ha ocurrido un error';
  static const String errorNetwork = 'Error de conexión. Verifica tu internet.';
  static const String errorServer = 'Error del servidor. Intenta de nuevo.';
  static const String retry = 'Intentar de nuevo';
  static const String empty = 'Sin datos';
  static const String cancel = 'Cancelar';
  static const String confirm = 'Confirmar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String save = 'Guardar';
  static const String search = 'Buscar...';
  static const String noResults = 'Sin resultados';
  static const String yes = 'Sí';
  static const String no = 'No';
  static const String ok = 'Aceptar';

  // Validation
  static const String fieldRequired = 'Este campo es obligatorio';
  static const String invalidEmail = 'Ingresa un correo válido';
  static const String invalidPassword =
      'Mínimo 8 caracteres, 1 mayúscula y 1 número';
  static const String passwordMismatch = 'Las contraseñas no coinciden';
  static const String invalidPhone = 'Ingresa un teléfono válido';
}
