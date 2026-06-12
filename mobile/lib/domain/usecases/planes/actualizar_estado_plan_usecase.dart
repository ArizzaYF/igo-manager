import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/repositories/plan_repository.dart';

class ActualizarEstadoPlanUseCase {
  final PlanRepository _repository;

  ActualizarEstadoPlanUseCase(this._repository);

  Future<Either<Failure, void>> call(String planId, String nuevoEstado) {
    return _repository.updatePlanStatus(planId, nuevoEstado);
  }
}
