import 'package:equatable/equatable.dart';

class PlanModel extends Equatable {
  final String id;
  final String initiativeId;
  final String userId;
  final DateTime? deadlineAt;
  final double? estimatedBudget;
  final List<String> allies;
  final String? responsible;
  final String status;
  final int progressPercent;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlanModel({
    required this.id,
    required this.initiativeId,
    required this.userId,
    this.deadlineAt,
    this.estimatedBudget,
    this.allies = const [],
    this.responsible,
    this.status = 'pendiente',
    this.progressPercent = 0,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      initiativeId: json['initiative_id'] as String? ?? json['iniciativa_id'] as String,
      userId: json['user_id'] as String,
      deadlineAt: json['deadline_at'] != null
          ? DateTime.parse(json['deadline_at'] as String)
          : null,
      estimatedBudget: (json['estimated_budget'] as num?)?.toDouble(),
      allies: (json['allies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      responsible: json['responsible'] as String?,
      status: json['status'] as String? ?? 'pendiente',
      progressPercent: json['progress_percent'] as int? ?? 0,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'initiative_id': initiativeId,
      'user_id': userId,
      'deadline_at': deadlineAt?.toIso8601String(),
      'estimated_budget': estimatedBudget,
      'allies': allies,
      'responsible': responsible,
      'status': status,
      'progress_percent': progressPercent,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PlanModel copyWith({
    String? id,
    String? initiativeId,
    String? userId,
    DateTime? deadlineAt,
    double? estimatedBudget,
    List<String>? allies,
    String? responsible,
    String? status,
    int? progressPercent,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlanModel(
      id: id ?? this.id,
      initiativeId: initiativeId ?? this.initiativeId,
      userId: userId ?? this.userId,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      allies: allies ?? this.allies,
      responsible: responsible ?? this.responsible,
      status: status ?? this.status,
      progressPercent: progressPercent ?? this.progressPercent,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        initiativeId,
        userId,
        deadlineAt,
        estimatedBudget,
        allies,
        responsible,
        status,
        progressPercent,
        completedAt,
        createdAt,
        updatedAt,
      ];
}

class TaskModel extends Equatable {
  final String id;
  final String planId;
  final String title;
  final String? description;
  final String? responsible;
  final DateTime? dueDate;
  final double? budget;
  final String status;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.planId,
    required this.title,
    this.description,
    this.responsible,
    this.dueDate,
    this.budget,
    this.status = 'pendiente',
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      planId: json['plan_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      responsible: json['responsible'] as String?,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      budget: (json['budget'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'pendiente',
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'plan_id': planId,
      'title': title,
      'description': description,
      'responsible': responsible,
      'due_date': dueDate?.toIso8601String(),
      'budget': budget,
      'status': status,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? planId,
    String? title,
    String? description,
    String? responsible,
    DateTime? dueDate,
    double? budget,
    String? status,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      title: title ?? this.title,
      description: description ?? this.description,
      responsible: responsible ?? this.responsible,
      dueDate: dueDate ?? this.dueDate,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
        createdAt,
        updatedAt,
      ];
}
