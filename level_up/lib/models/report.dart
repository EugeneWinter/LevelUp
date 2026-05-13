import 'package:flutter/material.dart';

enum ReportStatus {
  pending,
  confirmed,
  inProgress,
  resolved,
  rejected,
  notRelevant,
}

class Report {
  final String id;
  final String category;
  final String description;
  final String? imagePath;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime createdAt;
  final ReportStatus status;
  final int expReward;
  final int upvotes;
  final int notRelevantVotes;

  Report({
    required this.id,
    required this.category,
    required this.description,
    this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdAt,
    this.status = ReportStatus.pending,
    this.expReward = 50,
    this.upvotes = 0,
    this.notRelevantVotes = 0,
  });

  Report copyWith({
    ReportStatus? status,
    int? upvotes,
    int? notRelevantVotes,
  }) {
    return Report(
      id: id,
      category: category,
      description: description,
      imagePath: imagePath,
      latitude: latitude,
      longitude: longitude,
      address: address,
      createdAt: createdAt,
      status: status ?? this.status,
      expReward: expReward,
      upvotes: upvotes ?? this.upvotes,
      notRelevantVotes: notRelevantVotes ?? this.notRelevantVotes,
    );
  }

  Color get statusColor {
    switch (status) {
      case ReportStatus.pending:
        return Colors.orange;
      case ReportStatus.confirmed:
        return Colors.blue;
      case ReportStatus.inProgress:
        return Colors.amber;
      case ReportStatus.resolved:
        return Colors.green;
      case ReportStatus.rejected:
        return Colors.red;
      case ReportStatus.notRelevant:
        return Colors.blueGrey;
    }
  }

  String get statusText {
    switch (status) {
      case ReportStatus.pending:
        return 'На модерации';
      case ReportStatus.confirmed:
        return 'Подтверждён';
      case ReportStatus.inProgress:
        return 'В работе';
      case ReportStatus.resolved:
        return 'Решён';
      case ReportStatus.rejected:
        return 'Отклонён';
      case ReportStatus.notRelevant:
        return 'Не актуален';
    }
  }

  IconData get statusIcon {
    switch (status) {
      case ReportStatus.pending:
        return Icons.hourglass_top;
      case ReportStatus.confirmed:
        return Icons.check_circle_outline;
      case ReportStatus.inProgress:
        return Icons.engineering;
      case ReportStatus.resolved:
        return Icons.check_circle;
      case ReportStatus.rejected:
        return Icons.cancel;
      case ReportStatus.notRelevant:
        return Icons.visibility_off_rounded;
    }
  }
}