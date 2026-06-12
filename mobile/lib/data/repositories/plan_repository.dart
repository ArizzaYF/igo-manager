import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/supabase_client.dart';
import '../models/plan_accion_model.dart';

class PlanRepository {
  Future<Either<Failure, List<PlanModel>>> getPlans(String userId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('action_plans')
          .select()
          .eq('user_id', userId)
          .neq('status', 'abortado')
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(list);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener planes: $e'));
    }
  }

  Future<Either<Failure, PlanModel>> createPlan(PlanModel plan) async {
    try {
      final response = await SupabaseClientManager.client
          .from('action_plans')
          .insert(plan.toJson())
          .select()
          .single();

      final created = PlanModel.fromJson(response as Map<String, dynamic>);
      return Right(created);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al crear plan: $e'));
    }
  }

  Future<Either<Failure, void>> updatePlanStatus(
      String id, String status) async {
    try {
      await SupabaseClientManager.client
          .from('action_plans')
          .update({
            'status': status,
            if (status == 'terminado')
              'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
      return const Right(null);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al actualizar estado del plan: $e'));
    }
  }

  Future<Either<Failure, void>> updatePlanProgress(
      String id, int progressPercent, String status) async {
    try {
      await SupabaseClientManager.client
          .from('action_plans')
          .update({
            'progress_percent': progressPercent,
            'status': status,
            if (status == 'terminado')
              'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
      return const Right(null);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al actualizar progreso del plan: $e'));
    }
  }

  Future<Either<Failure, List<TaskModel>>> getTasks(String planId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('action_plan_tasks')
          .select()
          .eq('plan_id', planId)
          .order('sort_order', ascending: true);

      final list = (response as List<dynamic>)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(list);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener tareas: $e'));
    }
  }

  Future<Either<Failure, TaskModel>> createTask(TaskModel task) async {
    try {
      final response = await SupabaseClientManager.client
          .from('action_plan_tasks')
          .insert(task.toJson())
          .select()
          .single();

      final created = TaskModel.fromJson(response as Map<String, dynamic>);
      return Right(created);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al crear tarea: $e'));
    }
  }

  Future<Either<Failure, PlanModel>> getPlanById(String id) async {
    try {
      final response = await SupabaseClientManager.client
          .from('action_plans')
          .select()
          .eq('id', id)
          .single();

      return Right(
          PlanModel.fromJson(response as Map<String, dynamic>));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener plan: $e'));
    }
  }

  Future<Either<Failure, void>> updateTaskStatus(
      String id, String status) async {
    try {
      await SupabaseClientManager.client
          .from('action_plan_tasks')
          .update({'status': status})
          .eq('id', id);
      return const Right(null);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al actualizar estado de tarea: $e'));
    }
  }
}
