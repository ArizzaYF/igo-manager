import 'package:dartz/dartz.dart';
import 'package:igo_manager/core/errors/failures.dart';
import 'package:igo_manager/data/models/usuario_model.dart';
import 'package:igo_manager/data/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, UsuarioModel>> call({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String companyName,
    required String sector,
    required String companySize,
    required String ageRange,
    required String gender,
    required bool termsAccepted,
  }) {
    return _repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      companyName: companyName,
      sector: sector,
      companySize: companySize,
      ageRange: ageRange,
      gender: gender,
      termsAccepted: termsAccepted,
    );
  }
}
