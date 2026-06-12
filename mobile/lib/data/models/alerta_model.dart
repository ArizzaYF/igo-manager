import 'package:equatable/equatable.dart';

class AlertaModel extends Equatable {
  final String id;
  final String userId;
  final String? planId;
  final String? initiativeId;
  final String type;
  final String title;
  final String body;
  final DateTime scheduledAt;
  final DateTime? sentAt;
  final String status;
  final Map<String, dynamic> metadata;

  const AlertaModel({
    required this.id,
    required this.userId,
    this.planId,
    this.initiativeId,
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledAt,
    this.sentAt,
    this.status = 'pendiente',
    this.metadata = const {},
  });

  factory AlertaModel.fromJson(Map<String, dynamic> json) {
    return AlertaModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as String?,
      initiativeId: json['initiative_id'] as String?,
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      status: json['status'] as String? ?? 'pendiente',
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_id': planId,
      'initiative_id': initiativeId,
      'type': type,
      'title': title,
      'body': body,
      'scheduled_at': scheduledAt.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'status': status,
      'metadata': metadata,
    };
  }

  AlertaModel copyWith({
    String? id,
    String? userId,
    String? planId,
    String? initiativeId,
    String? type,
    String? title,
    String? body,
    DateTime? scheduledAt,
    DateTime? sentAt,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    return AlertaModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      initiativeId: initiativeId ?? this.initiativeId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        initiativeId,
        type,
        title,
        body,
        scheduledAt,
        sentAt,
        status,
        metadata,
      ];
}
