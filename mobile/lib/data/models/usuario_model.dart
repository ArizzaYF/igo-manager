import 'package:equatable/equatable.dart';

class UsuarioModel extends Equatable {
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
  final DateTime createdAt;
  final DateTime updatedAt;

  const UsuarioModel({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      companyName: json['company_name'] as String?,
      sector: json['sector'] as String?,
      companySize: json['company_size'] as String?,
      ageRange: json['age_range'] as String?,
      gender: json['gender'] as String?,
      userType: json['user_type'] as String? ?? 'emprendedor',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'company_name': companyName,
      'sector': sector,
      'company_size': companySize,
      'age_range': ageRange,
      'gender': gender,
      'user_type': userType,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UsuarioModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? companyName,
    String? sector,
    String? companySize,
    String? ageRange,
    String? gender,
    String? userType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      companyName: companyName ?? this.companyName,
      sector: sector ?? this.sector,
      companySize: companySize ?? this.companySize,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
        createdAt,
        updatedAt,
      ];
}
