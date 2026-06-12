import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? companyName;
  final String? sector;
  final String? companySize;
  final String? ageRange;
  final String? gender;
  final String userType;
  final bool isActive;

  const Usuario({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.companyName,
    this.sector,
    this.companySize,
    this.ageRange,
    this.gender,
    this.userType = 'emprendedor',
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phone,
        companyName,
        sector,
        companySize,
        ageRange,
        gender,
        userType,
        isActive,
      ];
}
