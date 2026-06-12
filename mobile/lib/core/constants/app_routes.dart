class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String login = '/login';
  static const String terms = '/terms';
  static const String iniciativas = '/iniciativas';
  static const String iniciativasCreate = '/iniciativas/create';
  static const String iniciativaDetail = '/iniciativas/:id';
  static const String priorizacion = '/priorizacion/:id';
  static const String matriz = '/matriz';
  static const String planes = '/planes';
  static const String planesCreate = '/planes/create/:iniciativaId';
  static const String planDetail = '/planes/:id';
  static const String perfil = '/perfil';
  static const String configuracion = '/configuracion';
}
