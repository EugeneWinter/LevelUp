import 'constants.dart';

class Helpers {
  static int getLevelForExp(int exp) {
    int level = 1;
    for (var entry in AppConstants.levelThresholds.entries) {
      if (exp >= entry.value) {
        level = entry.key;
      }
    }
    return level;
  }

  static double getProgressToNextLevel(int exp) {
    int currentLevel = getLevelForExp(exp);
    int currentThreshold = AppConstants.levelThresholds[currentLevel] ?? 0;

    if (currentLevel >= 6) return 1.0;

    int nextThreshold = AppConstants.levelThresholds[currentLevel + 1] ?? 5000;
    int progressInLevel = exp - currentThreshold;
    int levelRange = nextThreshold - currentThreshold;

    return (progressInLevel / levelRange).clamp(0.0, 1.0);
  }

  static int getExpToNextLevel(int exp) {
    int currentLevel = getLevelForExp(exp);
    if (currentLevel >= 6) return 0;

    int nextThreshold = AppConstants.levelThresholds[currentLevel + 1] ?? 5000;
    return nextThreshold - exp;
  }

  static String getLevelName(int exp) {
    int level = getLevelForExp(exp);
    return AppConstants.levelNames[level] ?? 'Новичок';
  }

  static String getTimeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    if (diff.inDays < 7) return '${diff.inDays} дн назад';
    return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }
}