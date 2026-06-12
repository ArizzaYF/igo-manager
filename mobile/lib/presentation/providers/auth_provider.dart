import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/datasources/local_storage.dart';
import 'package:igo_manager/data/models/usuario_model.dart';
import 'package:igo_manager/data/repositories/auth_repository.dart';
import 'package:igo_manager/domain/usecases/auth/login_usecase.dart';
import 'package:igo_manager/domain/usecases/auth/logout_usecase.dart';
import 'package:igo_manager/domain/usecases/auth/register_usecase.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(localStorageProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UsuarioModel?>> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final LocalStorage _localStorage;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required LocalStorage localStorage,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _localStorage = localStorage,
        super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _loginUseCase(email, password);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String companyName,
    required String sector,
    required String companySize,
    required String ageRange,
    required String gender,
    required bool termsAccepted,
  }) async {
    state = const AsyncValue.loading();
    final result = await _registerUseCase(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      companyName: companyName,
      sector: sector,
      companySize: companySize,
      ageRange: ageRange,
      gender: gender,
      termsAccepted: termsAccepted,
    );
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await _logoutUseCase();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> checkSession() async {
    state = const AsyncValue.loading();
    final sessionData = _localStorage.getUserSession();
    if (sessionData == null) {
      state = const AsyncValue.data(null);
      return;
    }
    final user = UsuarioModel.fromJson(sessionData);
    state = AsyncValue.data(user);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UsuarioModel?>>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    localStorage: ref.read(localStorageProvider),
  );
});
