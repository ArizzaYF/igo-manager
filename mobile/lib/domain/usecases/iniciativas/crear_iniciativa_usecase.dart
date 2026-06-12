import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/data/repositories/iniciativa_repository.dart';

class CrearIniciativaUseCase {
  final IniciativaRepository _repository;

  CrearIniciativaUseCase(this._repository);

  Future<Either<Failure, IniciativaModel>> call(IniciativaModel iniciativa) {
    return _repository.createIniciativa(iniciativa);
  }
}
