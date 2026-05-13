import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/exp_bar.dart';
import '../widgets/level_badge.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'create_report_screen.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart';
import 'report_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedTabIndex,
            children: [
              _MapTab(state: state),
              _FeedTab(state: state),
              const ProfileScreen(),
              const LeaderboardScreen(),
            ],
          ),
          floatingActionButton: SizedBox(
            width: 64,
            height: 64,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateReportScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.accentGreen,
              foregroundColor: AppTheme.primaryDark,
              elevation: 12,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 28,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: AppTheme.surfaceDark,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Карта',
                  isActive: state.selectedTabIndex == 0,
                  onTap: () => state.setTabIndex(0),
                ),
                _NavBarItem(
                  icon: Icons.list_alt_outlined,
                  activeIcon: Icons.list_alt,
                  label: 'Лента',
                  isActive: state.selectedTabIndex == 1,
                  onTap: () => state.setTabIndex(1),
                ),
                const SizedBox(width: 48),
                _NavBarItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Профиль',
                  isActive: state.selectedTabIndex == 2,
                  onTap: () => state.setTabIndex(2),
                ),
                _NavBarItem(
                  icon: Icons.leaderboard_outlined,
                  activeIcon: Icons.leaderboard,
                  label: 'Рейтинг',
                  isActive: state.selectedTabIndex == 3,
                  onTap: () => state.setTabIndex(3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// NAV BAR ITEM
// ─────────────────────────────────────────────

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppTheme.accentGreen
                  : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppTheme.accentGreen
                    : AppTheme.textSecondary,
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MAP TAB
// ─────────────────────────────────────────────

class _MapTab extends StatelessWidget {
  final AppState state;

  const _MapTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header с профилем и EXP
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                LevelBadge(exp: state.user.totalExp, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ExpBar(
                        currentExp: state.user.totalExp,
                        showLabel: false,
                        height: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.expPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.user.totalExp} EXP',
                    style: const TextStyle(
                      color: AppTheme.expPurple,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Карта
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surfaceLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // ── Зумируемая область: фон + маркеры ──
                    Positioned.fill(
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        boundaryMargin: const EdgeInsets.all(0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final mapWidth = constraints.maxWidth;
                            final mapHeight = constraints.maxHeight;

                            return SizedBox(
                              width: mapWidth,
                              height: mapHeight,
                              child: Stack(
                                children: [
                                  // ── Фоновая картинка ──
                                  Positioned.fill(
                                    child: Image.asset(
                                      'assets/images/donskoy_map_placeholder.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF1A2332),
                                                Color(0xFF0F1923),
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  size: 56,
                                                  color: AppTheme.primaryBlue
                                                      .withOpacity(0.4),
                                                ),
                                                const SizedBox(height: 12),
                                                const Text(
                                                  'Не найден плейсхолдер карты',
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.textPrimary,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                const Text(
                                                  'Добавь файл:\nassets/images/donskoy_map_placeholder.jpg',
                                                  textAlign:
                                                      TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .textSecondary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // ── Затемняющий градиент ──
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.15),
                                            Colors.black.withOpacity(0.20),
                                            Colors.black.withOpacity(0.40),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ── Маркеры ──
                                  ...state.visibleReports
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final report = entry.value;

                                    // Процентные координаты на карте
                                    final topPercent =
                                        _pinPositions[index %
                                            _pinPositions.length]['top']!;
                                    final leftPercent =
                                        _pinPositions[index %
                                            _pinPositions.length]['left']!;

                                    return Positioned(
                                      top: mapHeight * topPercent,
                                      left: mapWidth * leftPercent,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ReportDetailScreen(
                                                      report: report),
                                            ),
                                          );
                                        },
                                        child:
                                            _MapPin(report: report),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ── UI поверх карты (НЕ зумируется) ──

                    // Название города
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Донской',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Городская карта репортов',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Легенда
                    const Positioned(
                      top: 16,
                      right: 16,
                      child: _MapLegendCard(),
                    ),

                    // Плашка-плейсхолдер
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Фон карты — временный плейсхолдер для демо. '
                                'API карт будет подключён в production-версии.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Подсказка о зуме
                    Positioned(
                      bottom: 70,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.pinch,
                                color: Colors.white54,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Двумя пальцами для масштабирования',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MAP LEGEND CARD
// ─────────────────────────────────────────────

class _MapLegendCard extends StatelessWidget {
  const _MapLegendCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статусы',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          _LegendLine(color: Colors.orange, label: 'На модерации'),
          SizedBox(height: 6),
          _LegendLine(color: Colors.blue, label: 'Подтверждён'),
          SizedBox(height: 6),
          _LegendLine(color: Colors.amber, label: 'В работе'),
          SizedBox(height: 6),
          _LegendLine(color: Colors.green, label: 'Решён'),
        ],
      ),
    );
  }
}

class _LegendLine extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendLine({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MAP PIN
// ─────────────────────────────────────────────

class _MapPin extends StatelessWidget {
  final dynamic report;

  const _MapPin({required this.report});

  @override
  Widget build(BuildContext context) {
    final String emoji =
        AppConstants.categoryIcons[report.category] ?? '📋';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: report.statusColor.withOpacity(0.92),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: report.statusColor.withOpacity(0.45),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        CustomPaint(
          size: const Size(12, 8),
          painter: _TrianglePainter(
            color: report.statusColor.withOpacity(0.92),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// FEED TAB
// ─────────────────────────────────────────────

class _FeedTab extends StatelessWidget {
  final AppState state;

  const _FeedTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Лента репортов',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${state.visibleReports.length} репортов в вашем городе',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              // нижний padding чтобы FAB не перекрывал последнюю карточку
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.visibleReports[index];
                return _ReportCard(report: report);
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<Map<String, double>> _pinPositions = [
  {'top': 0.22, 'left': 0.15},
  {'top': 0.38, 'left': 0.55},
  {'top': 0.52, 'left': 0.30},
  {'top': 0.18, 'left': 0.70},
  {'top': 0.65, 'left': 0.50},
  {'top': 0.45, 'left': 0.78},
  {'top': 0.72, 'left': 0.20},
  {'top': 0.30, 'left': 0.42},
];

class _ReportCard extends StatelessWidget {
  final dynamic report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final String emoji =
        AppConstants.categoryIcons[report.category] ?? '📋';
    final String timeAgo = Helpers.getTimeAgo(report.createdAt);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ReportDetailScreen(report: report),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: report.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.category,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        report.address,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: report.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: report.statusColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        report.statusIcon,
                        size: 14,
                        color: report.statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        report.statusText,
                        style: TextStyle(
                          color: report.statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report.description,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppTheme.textSecondary.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.thumb_up_outlined,
                  size: 14,
                  color: AppTheme.textSecondary.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '${report.upvotes}',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '+${report.expReward} EXP',
                  style: TextStyle(
                    color: AppTheme.expPurple.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}