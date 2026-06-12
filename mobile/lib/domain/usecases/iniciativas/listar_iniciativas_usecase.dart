import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/data/repositories/iniciativa_repository.dart';

class ListarIniciativasUseCase {
  final IniciativaRepository _repository;

  ListarIniciativasUseCase(this._repository);

  Future<Either<Failure, List<IniciativaModel>>> call(String userId) {
    return _repository.getInitiatives(userId);
  }
}
