import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/models/plan_accion_model.dart';
import 'package:igo_manager/data/repositories/plan_repository.dart';

class CrearPlanUseCase {
  final PlanRepository _repository;

  CrearPlanUseCase(this._repository);

  Future<Either<Failure, PlanModel>> call(PlanModel plan) {
    return _repository.createPlan(plan);
  }
}
