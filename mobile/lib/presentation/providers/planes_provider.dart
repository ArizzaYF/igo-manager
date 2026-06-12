import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/models/plan_accion_model.dart';
import 'package:igo_manager/data/repositories/plan_repository.dart';
import 'package:igo_manager/domain/usecases/planes/actualizar_estado_plan_usecase.dart';
import 'package:igo_manager/domain/usecases/planes/crear_plan_usecase.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository();
});

final crearPlanUseCaseProvider =
    Provider<CrearPlanUseCase>((ref) => CrearPlanUseCase(ref.read(planRepositoryProvider)));

final actualizarEstadoPlanUseCaseProvider =
    Provider<ActualizarEstadoPlanUseCase>(
        (ref) => ActualizarEstadoPlanUseCase(ref.read(planRepositoryProvider)));

class PlanesNotifier extends StateNotifier<AsyncValue<List<PlanModel>>> {
  final PlanRepository _planRepository;
  final CrearPlanUseCase _crearPlan;
  final ActualizarEstadoPlanUseCase _actualizarEstado;

  PlanesNotifier({
    required PlanRepository planRepository,
    required CrearPlanUseCase crearPlan,
    required ActualizarEstadoPlanUseCase actualizarEstado,
  })  : _planRepository = planRepository,
        _crearPlan = crearPlan,
        _actualizarEstado = actualizarEstado,
        super(const AsyncValue.data([]));

  Future<void> loadPlans(String userId) async {
    state = const AsyncValue.loading();
    final result = await _planRepository.getPlans(userId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      AsyncValue.data,
    );
  }

  Future<PlanModel?> createPlan(PlanModel plan) async {
    final result = await _crearPlan(plan);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
      (nuevo) {
        state = state.whenData((list) => [...list, nuevo]);
        return nuevo;
      },
    );
  }

  Future<void> updateStatus(String planId, String nuevoEstado) async {
    final result = await _actualizarEstado(planId, nuevoEstado);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = state.whenData(
          (list) => list
              .map((p) => p.id == planId ? p.copyWith(status: nuevoEstado) : p)
              .toList(),
        );
      },
    );
  }

  void updatePlanLocally(PlanModel plan) {
    state = state.whenData(
      (list) => list.map((p) => p.id == plan.id ? plan : p).toList(),
    );
  }
}

final planesProvider =
    StateNotifierProvider<PlanesNotifier, AsyncValue<List<PlanModel>>>((ref) {
  return PlanesNotifier(
    planRepository: ref.read(planRepositoryProvider),
    crearPlan: ref.read(crearPlanUseCaseProvider),
    actualizarEstado: ref.read(actualizarEstadoPlanUseCaseProvider),
  );
});
