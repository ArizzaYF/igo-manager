import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/models/usuario_model.dart';
import 'package:igo_manager/data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UsuarioModel>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
