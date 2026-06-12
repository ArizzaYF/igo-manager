import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/supabase_client.dart';
import '../models/usuario_model.dart';

class UsuarioRepository {
  Future<Either<Failure, UsuarioModel>> getProfile(String userId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return Right(
          UsuarioModel.fromJson(response as Map<String, dynamic>));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener perfil: $e'));
    }
  }

  Future<Either<Failure, UsuarioModel>> updateProfile(
      UsuarioModel usuario) async {
    try {
      final response = await SupabaseClientManager.client
          .from('profiles')
          .update(usuario.toJson())
          .eq('id', usuario.id)
          .select()
          .single();

      return Right(
          UsuarioModel.fromJson(response as Map<String, dynamic>));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al actualizar perfil: $e'));
    }
  }
}
