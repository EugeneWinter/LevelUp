// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class LevelBadge extends StatelessWidget {
  final int exp;
  final double size;

  const LevelBadge({
    super.key,
    required this.exp,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    int level = Helpers.getLevelForExp(exp);
    double progress = Helpers.getProgressToNextLevel(exp);

    Color badgeColor;
    switch (level) {
      case 1:
        badgeColor = Colors.grey;
        break;
      case 2:
        badgeColor = Colors.teal;
        break;
      case 3:
        badgeColor = Colors.blue;
        break;
      case 4:
        badgeColor = AppTheme.expPurple;
        break;
      case 5:
        badgeColor = AppTheme.accentOrange;
        break;
      case 6:
        badgeColor = AppTheme.goldColor;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: AppTheme.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
            ),
          ),
          Container(
            width: size - 12,
            height: size - 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  badgeColor,
                  badgeColor.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$level',
                style: TextStyle(
                  color: level >= 5 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}