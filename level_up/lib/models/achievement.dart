import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int requiredCount;
  final int currentCount;
  final bool isUnlocked;
  final Color color;
  final int expReward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requiredCount,
    this.currentCount = 0,
    this.isUnlocked = false,
    this.color = Colors.blueGrey,
    this.expReward = 100,
  });

  double get progress => (currentCount / requiredCount).clamp(0.0, 1.0);

  Achievement copyWith({
    int? currentCount,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      emoji: emoji,
      requiredCount: requiredCount,
      currentCount: currentCount ?? this.currentCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      color: color,
      expReward: expReward,
    );
  }
}