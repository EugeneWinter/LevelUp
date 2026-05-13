// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class ExpBar extends StatelessWidget {
  final int currentExp;
  final bool showLabel;
  final double height;

  const ExpBar({
    super.key,
    required this.currentExp,
    this.showLabel = true,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    double progress = Helpers.getProgressToNextLevel(currentExp);
    int expToNext = Helpers.getExpToNextLevel(currentExp);
    int level = Helpers.getLevelForExp(currentExp);
    String levelName = Helpers.getLevelName(currentExp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.expPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.expPurple.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        'LV $level',
                        style: const TextStyle(
                          color: AppTheme.expPurple,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      levelName,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  level >= 6
                      ? 'MAX LEVEL'
                      : '$expToNext EXP до LV ${level + 1}',
                  style: TextStyle(
                    color: level >= 6
                        ? AppTheme.goldColor
                        : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    gradient: const LinearGradient(
                      colors: [AppTheme.expPurple, Color(0xFFB388FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.expPurple.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$currentExp EXP',
                style: const TextStyle(
                  color: AppTheme.expPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}