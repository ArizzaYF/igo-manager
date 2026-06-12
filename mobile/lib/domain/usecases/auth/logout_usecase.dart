import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
