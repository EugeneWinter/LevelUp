import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/report.dart';
import '../models/user_profile.dart';
import '../models/achievement.dart';

class AppState extends ChangeNotifier {
  final _uuid = const Uuid();

  UserProfile _user = UserProfile(
    name: 'Евгений Зимин',
    district: 'Центральный',
    totalExp: 350,
    totalReports: 7,
    confirmedReports: 5,
    resolvedReports: 2,
    streak: 3,
  );

  final List<Report> _reports = [];
  final List<Achievement> _achievements = [];
  int _selectedTabIndex = 0;

  AppState() {
    _initDemoData();
    _initAchievements();
  }

  UserProfile get user => _user;
  List<Report> get reports => List.unmodifiable(_reports);
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  int get selectedTabIndex => _selectedTabIndex;

  List<Report> get visibleReports => _reports
      .where(
        (r) =>
            r.status != ReportStatus.rejected &&
            r.status != ReportStatus.notRelevant,
      )
      .toList();

  List<Report> get userReports =>
      _reports.where((r) => r.status != ReportStatus.rejected).toList();

  List<Report> get resolvedReports =>
      _reports.where((r) => r.status == ReportStatus.resolved).toList();

  Report? getReportById(String id) {
    final index = _reports.indexWhere((r) => r.id == id);
    if (index == -1) return null;
    return _reports[index];
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void addReport({
    required String category,
    required String description,
    String? imagePath,
    required double latitude,
    required double longitude,
    String address = 'Определяется...',
  }) {
    final report = Report(
      id: _uuid.v4(),
      category: category,
      description: description,
      imagePath: imagePath,
      latitude: latitude,
      longitude: longitude,
      address: address,
      createdAt: DateTime.now(),
      status: ReportStatus.pending,
      expReward: 50,
    );

    _reports.insert(0, report);

    _user = _user.copyWith(
      totalExp: _user.totalExp + 50,
      totalReports: _user.totalReports + 1,
    );

    _checkAchievements();
    notifyListeners();
  }

  void upvoteReport(String reportId) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index == -1) return;

    final current = _reports[index];

    if (current.status == ReportStatus.rejected ||
        current.status == ReportStatus.notRelevant) {
      return;
    }

    _reports[index] = current.copyWith(
      upvotes: current.upvotes + 1,
    );

    _user = _user.copyWith(totalExp: _user.totalExp + 5);
    notifyListeners();
  }

  void markReportNotRelevant(String reportId) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index == -1) return;

    final current = _reports[index];

    if (current.status == ReportStatus.rejected ||
        current.status == ReportStatus.resolved ||
        current.status == ReportStatus.notRelevant) {
      return;
    }

    final newNotRelevantVotes = current.notRelevantVotes + 1;

    _reports[index] = current.copyWith(
      notRelevantVotes: newNotRelevantVotes,
      status: newNotRelevantVotes >= 3
          ? ReportStatus.notRelevant
          : current.status,
    );

    notifyListeners();
  }

  void _checkAchievements() {
    for (int i = 0; i < _achievements.length; i++) {
      final a = _achievements[i];
      if (a.isUnlocked) continue;

      int newCount = 0;
      switch (a.id) {
        case 'first_report':
          newCount = _user.totalReports;
          break;
        case 'five_reports':
          newCount = _user.totalReports;
          break;
        case 'twenty_reports':
          newCount = _user.totalReports;
          break;
        case 'first_resolved':
          newCount = _user.resolvedReports;
          break;
        case 'streak_7':
          newCount = _user.streak;
          break;
        case 'lighting_expert':
          newCount = _reports.where((r) => r.category == 'Освещение').length;
          break;
        case 'road_warrior':
          newCount =
              _reports.where((r) => r.category == 'Дорожное покрытие').length;
          break;
      }

      final unlocked = newCount >= a.requiredCount;
      _achievements[i] = a.copyWith(
        currentCount: newCount,
        isUnlocked: unlocked,
      );

      if (unlocked && !a.isUnlocked) {
        _user = _user.copyWith(
          totalExp: _user.totalExp + a.expReward,
        );
      }
    }
  }

  void _initAchievements() {
    final lightingCount =
        _reports.where((r) => r.category == 'Освещение').length;
    final roadCount =
        _reports.where((r) => r.category == 'Дорожное покрытие').length;

    _achievements.addAll([
      Achievement(
        id: 'first_report',
        title: 'Первый шаг',
        description: 'Отправь свой первый репорт',
        emoji: '🎯',
        requiredCount: 1,
        currentCount: _user.totalReports.clamp(0, 1),
        isUnlocked: _user.totalReports >= 1,
        color: Colors.blue,
        expReward: 50,
      ),
      Achievement(
        id: 'five_reports',
        title: 'Наблюдатель',
        description: 'Отправь 5 репортов',
        emoji: '👁️',
        requiredCount: 5,
        currentCount: _user.totalReports.clamp(0, 5),
        isUnlocked: _user.totalReports >= 5,
        color: Colors.teal,
        expReward: 150,
      ),
      Achievement(
        id: 'twenty_reports',
        title: 'Городской инспектор',
        description: 'Отправь 20 репортов',
        emoji: '🔍',
        requiredCount: 20,
        currentCount: _user.totalReports.clamp(0, 20),
        isUnlocked: _user.totalReports >= 20,
        color: Colors.indigo,
        expReward: 500,
      ),
      Achievement(
        id: 'first_resolved',
        title: 'Результат!',
        description: 'Твой репорт привёл к решению проблемы',
        emoji: '✅',
        requiredCount: 1,
        currentCount: _user.resolvedReports.clamp(0, 1),
        isUnlocked: _user.resolvedReports >= 1,
        color: Colors.green,
        expReward: 200,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Неделя активности',
        description: '7 дней подряд отправляй репорты',
        emoji: '🔥',
        requiredCount: 7,
        currentCount: _user.streak.clamp(0, 7),
        isUnlocked: _user.streak >= 7,
        color: Colors.deepOrange,
        expReward: 300,
      ),
      Achievement(
        id: 'lighting_expert',
        title: 'Да будет свет',
        description: 'Отправь 5 репортов об освещении',
        emoji: '💡',
        requiredCount: 5,
        currentCount: lightingCount.clamp(0, 5),
        isUnlocked: lightingCount >= 5,
        color: Colors.amber,
        expReward: 200,
      ),
      Achievement(
        id: 'road_warrior',
        title: 'Дорожный воин',
        description: 'Отправь 5 репортов о дорогах',
        emoji: '🛣️',
        requiredCount: 5,
        currentCount: roadCount.clamp(0, 5),
        isUnlocked: roadCount >= 5,
        color: Colors.grey,
        expReward: 200,
      ),
    ]);
  }

  void _initDemoData() {
    _reports.addAll([
      Report(
        id: _uuid.v4(),
        category: 'Освещение',
        description: 'Не горит фонарь у подъезда',
        latitude: 53.9680,
        longitude: 38.3290,
        address: 'ул. Ленина, 42',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: ReportStatus.confirmed,
        expReward: 50,
        upvotes: 12,
      ),
      Report(
        id: _uuid.v4(),
        category: 'Дорожное покрытие',
        description: 'Глубокая яма после дождей, опасно для машин',
        latitude: 53.9670,
        longitude: 38.3260,
        address: 'ул. Молодёжная, 15',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: ReportStatus.inProgress,
        expReward: 50,
        upvotes: 28,
      ),
      Report(
        id: _uuid.v4(),
        category: 'Благоустройство',
        description: 'Сломанная лавочка в парке',
        latitude: 53.9690,
        longitude: 38.3310,
        address: 'Парк Победы',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: ReportStatus.resolved,
        expReward: 50,
        upvotes: 45,
      ),
      Report(
        id: _uuid.v4(),
        category: 'ЖКХ',
        description: 'Течь трубы во дворе, лужа расширяется',
        latitude: 53.9665,
        longitude: 38.3245,
        address: 'ул. Советская, 8',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: ReportStatus.confirmed,
        expReward: 50,
        upvotes: 19,
      ),
      Report(
        id: _uuid.v4(),
        category: 'Безопасность',
        description: 'Открытый люк без ограждения',
        latitude: 53.9695,
        longitude: 38.3275,
        address: 'ул. Октябрьская, 23',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: ReportStatus.pending,
        expReward: 50,
        upvotes: 7,
        notRelevantVotes: 1,
      ),
    ]);
  }
}