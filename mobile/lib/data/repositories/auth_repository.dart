import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:uuid/uuid.dart';

import '../../core/errors/failures.dart';
import '../datasources/local_storage.dart';
import '../datasources/supabase_client.dart';
import '../models/usuario_model.dart';

class AuthRepository {
  final LocalStorage _localStorage;

  AuthRepository(this._localStorage);

  Future<Either<Failure, UsuarioModel>> login(
      String email, String password) async {
    try {
      final response = await SupabaseClientManager.client.rpc(
        'login_app_user',
        params: {'p_email': email, 'p_password': password},
      );

      final List<dynamic> rows;
      if (response is List) {
        rows = response;
      } else if (response is Map) {
        rows = [response];
      } else {
        return Left(AuthFailure('Credenciales inválidas'));
      }

      if (rows.isEmpty) {
        return Left(AuthFailure('Credenciales inválidas'));
      }

      final authData = Map<String, dynamic>.from(rows[0] as Map);
      final userId = authData['id'] as String?;

      Map<String, dynamic> userData;
      if (userId != null) {
        final profileResponse = await SupabaseClientManager.client
            .from('profiles')
            .select()
            .eq('id', userId)
            .single();
        userData = Map<String, dynamic>.from(profileResponse as Map);
        userData['user_type'] = authData['user_type'] ?? authData['role'] ?? 'emprendedor';
      } else {
        userData = authData;
      }

      final user = UsuarioModel.fromJson(userData);

      await _localStorage.saveUserSession(userData);
      return Right(user);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al iniciar sesión: $e'));
    }
  }

  Future<Either<Failure, UsuarioModel>> register({
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
    try {
      final userId = const Uuid().v4();

      final response = await SupabaseClientManager.client.rpc(
        'register_app_user',
        params: {
          'p_id': userId,
          'p_email': email,
          'p_password': password,
          'p_full_name': fullName,
          'p_phone': phone,
          'p_company_name': companyName,
          'p_sector': sector,
          'p_company_size': companySize,
          'p_age_range': ageRange,
          'p_gender': gender,
        },
      );

      final Map<String, dynamic> userData;
      if (response is Map) {
        userData = Map<String, dynamic>.from(response);
      } else {
        return Left(ServerFailure('Error inesperado al registrar'));
      }

      final user = UsuarioModel.fromJson(userData);
      await _localStorage.saveUserSession(userData);
      return Right(user);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al registrar: $e'));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await SupabaseClientManager.client.auth.signOut();
      await _localStorage.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al cerrar sesión: $e'));
    }
  }

  UsuarioModel? getCurrentUser() {
    final sessionData = _localStorage.getUserSession();
    if (sessionData == null) return null;
    return UsuarioModel.fromJson(sessionData);
  }
}
