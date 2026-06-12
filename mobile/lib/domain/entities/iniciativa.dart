import 'package:equatable/equatable.dart';

class Iniciativa extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final int importance;
  final int governability;
  final String? quadrant;
  final String status;

  const Iniciativa({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.importance = 5,
    this.governability = 5,
    this.quadrant,
    this.status = 'activa',
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        importance,
        governability,
        quadrant,
        status,
      ];
}
