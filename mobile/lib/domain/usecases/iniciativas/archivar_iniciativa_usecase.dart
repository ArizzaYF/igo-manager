import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/repositories/iniciativa_repository.dart';

class ArchivarIniciativaUseCase {
  final IniciativaRepository _repository;

  ArchivarIniciativaUseCase(this._repository);

  Future<Either<Failure, void>> call(String iniciativaId) {
    return _repository.deleteIniciativa(iniciativaId);
  }
}
