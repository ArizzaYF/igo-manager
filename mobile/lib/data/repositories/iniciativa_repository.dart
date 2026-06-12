import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/supabase_client.dart';
import '../models/iniciativa_model.dart';

class IniciativaRepository {
  Future<Either<Failure, List<IniciativaModel>>> getInitiatives(
      String userId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('initiatives')
          .select()
          .eq('user_id', userId)
          .neq('status', 'eliminada')
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((e) => IniciativaModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(list);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener iniciativas: $e'));
    }
  }

  Future<Either<Failure, IniciativaModel>> createIniciativa(
      IniciativaModel iniciativa) async {
    try {
      final response = await SupabaseClientManager.client
          .from('initiatives')
          .insert(iniciativa.toJson())
          .select()
          .single();

      final created =
          IniciativaModel.fromJson(response as Map<String, dynamic>);
      return Right(created);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al crear iniciativa: $e'));
    }
  }

  Future<Either<Failure, IniciativaModel>> updateIniciativa(
      IniciativaModel iniciativa) async {
    try {
      final response = await SupabaseClientManager.client
          .from('initiatives')
          .update(iniciativa.toJson())
          .eq('id', iniciativa.id)
          .select()
          .single();

      final updated =
          IniciativaModel.fromJson(response as Map<String, dynamic>);
      return Right(updated);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al actualizar iniciativa: $e'));
    }
  }

  Future<Either<Failure, void>> deleteIniciativa(String id) async {
    try {
      await SupabaseClientManager.client
          .from('initiatives')
          .update({'status': 'archivada'})
          .eq('id', id);
      return const Right(null);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al eliminar iniciativa: $e'));
    }
  }

  Future<Either<Failure, IniciativaModel>> getIniciativaById(
      String id) async {
    try {
      final response = await SupabaseClientManager.client
          .from('initiatives')
          .select()
          .eq('id', id)
          .single();

      return Right(
          IniciativaModel.fromJson(response as Map<String, dynamic>));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener iniciativa: $e'));
    }
  }
}
