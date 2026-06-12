import 'package:equatable/equatable.dart';

class PlanAccion extends Equatable {
  final String id;
  final String iniciativaId;
  final DateTime? deadlineAt;
  final double? budget;
  final List<String> allies;
  final String? responsible;
  final String status;
  final int progress;

  const PlanAccion({
    required this.id,
    required this.iniciativaId,
    this.deadlineAt,
    this.budget,
    this.allies = const [],
    this.responsible,
    this.status = 'pendiente',
    this.progress = 0,
  });

  @override
  List<Object?> get props => [
        id,
        iniciativaId,
        deadlineAt,
        budget,
        allies,
        responsible,
        status,
        progress,
      ];
}

class Tarea extends Equatable {
  final String id;
  final String planId;
  final String title;
  final String? description;
  final String? responsible;
  final DateTime? dueDate;
  final double? budget;
  final String status;
  final int sortOrder;

  const Tarea({
    required this.id,
    required this.planId,
    required this.title,
    this.description,
    this.responsible,
    this.dueDate,
    this.budget,
    this.status = 'pendiente',
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [
        id,
        planId,
        title,
        description,
        responsible,
        dueDate,
        budget,
        status,
        sortOrder,
      ];
}
