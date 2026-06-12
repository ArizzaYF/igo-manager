import 'package:equatable/equatable.dart';

import '../../core/utils/igo_calculator.dart';

class IniciativaModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? audioUrl;
  final String? transcriptionText;
  final int importance;
  final int governability;
  final String? quadrant;
  final String status;
  final DateTime? classifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IniciativaModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.audioUrl,
    this.transcriptionText,
    this.importance = 5,
    this.governability = 5,
    this.quadrant,
    this.status = 'activa',
    this.classifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get computedQuadrant {
    return IgoCalculator.getQuadrantLabel(
      IgoCalculator.calculateQuadrant(importance, governability),
    );
  }

  factory IniciativaModel.fromJson(Map<String, dynamic> json) {
    final importance = json['importance'] as int? ?? 5;
    final governability = json['governability'] as int? ?? 5;
    final quadrant = json['quadrant'] as String?;

    return IniciativaModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      audioUrl: json['audio_url'] as String?,
      transcriptionText: json['transcription_text'] as String?,
      importance: importance,
      governability: governability,
      quadrant: quadrant,
      status: json['status'] as String? ?? 'activa',
      classifiedAt: json['classified_at'] != null
          ? DateTime.parse(json['classified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'audio_url': audioUrl,
      'transcription_text': transcriptionText,
      'importance': importance,
      'governability': governability,
      'status': status,
      if (classifiedAt != null) 'classified_at': classifiedAt!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  IniciativaModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? audioUrl,
    String? transcriptionText,
    int? importance,
    int? governability,
    String? quadrant,
    String? status,
    DateTime? classifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IniciativaModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      audioUrl: audioUrl ?? this.audioUrl,
      transcriptionText: transcriptionText ?? this.transcriptionText,
      importance: importance ?? this.importance,
      governability: governability ?? this.governability,
      quadrant: quadrant ?? this.quadrant,
      status: status ?? this.status,
      classifiedAt: classifiedAt ?? this.classifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        audioUrl,
        transcriptionText,
        importance,
        governability,
        quadrant,
        status,
        classifiedAt,
        createdAt,
        updatedAt,
      ];
}
