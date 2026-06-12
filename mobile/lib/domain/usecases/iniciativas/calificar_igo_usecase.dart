import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/core/utils/igo_calculator.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/data/repositories/iniciativa_repository.dart';

class CalificarIgoUseCase {
  final IniciativaRepository _repository;

  CalificarIgoUseCase(this._repository);

  Future<Either<Failure, IniciativaModel>> call({
    required String iniciativaId,
    required int importance,
    required int governability,
  }) async {
    if (importance < 1 || importance > 10) {
      return Left(ValidationFailure('La importancia debe estar entre 1 y 10'));
    }
    if (governability < 1 || governability > 10) {
      return Left(
          ValidationFailure('La gobernabilidad debe estar entre 1 y 10'));
    }

    final result = await _repository.getIniciativaById(iniciativaId);
    return result.fold(
      (failure) => Left(failure),
      (iniciativa) {
        final updated = iniciativa.copyWith(
          importance: importance,
          governability: governability,
          quadrant: IgoCalculator.getQuadrantDbKey(
            IgoCalculator.calculateQuadrant(importance, governability),
          ),
          classifiedAt: DateTime.now(),
        );
        return _repository.updateIniciativa(updated);
      },
    );
  }
}
