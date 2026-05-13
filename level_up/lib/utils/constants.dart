class AppConstants {
  static const String appName = 'LEVEL UP';
  static const String tagline = 'Прокачай себя — улучши город';

  static const double defaultLat = 53.9676;
  static const double defaultLng = 38.3279;

  static const Map<int, String> levelNames = {
    1: 'Новичок',
    2: 'Наблюдатель',
    3: 'Патрульный',
    4: 'Инспектор',
    5: 'Хранитель',
    6: 'Легенда района',
  };

  static const Map<int, int> levelThresholds = {
    1: 0,
    2: 200,
    3: 500,
    4: 1200,
    5: 2500,
    6: 5000,
  };

  static const Map<int, String> levelDescriptions = {
    1: 'Только начал свой путь',
    2: '5+ подтверждённых репортов',
    3: '15+ репортов, доверие растёт',
    4: '30+ репортов, доступ к бонусам',
    5: '60+ репортов, модерация',
    6: 'Топ-1 в рейтинге района',
  };

  static const List<String> reportCategories = [
    'Освещение',
    'Дорожное покрытие',
    'Благоустройство',
    'ЖКХ',
    'Безопасность',
    'Другое',
  ];

  static const Map<String, String> categoryIcons = {
    'Освещение': '💡',
    'Дорожное покрытие': '🛣️',
    'Благоустройство': '🌳',
    'ЖКХ': '🏠',
    'Безопасность': '⚠️',
    'Другое': '📋',
  };
}