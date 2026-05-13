import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/achievement_card.dart';
import '../widgets/exp_bar.dart';
import '../widgets/level_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final user = state.user;
        final level = Helpers.getLevelForExp(user.totalExp);
        final levelName = Helpers.getLevelName(user.totalExp);
        final unlockedAchievements =
            state.achievements.where((a) => a.isUnlocked).length;

        final resolvedPercent = user.totalReports == 0
            ? 0
            : ((user.resolvedReports / user.totalReports) * 100).round();

        return Scaffold(
          backgroundColor: AppTheme.primaryDark,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(
                    title: 'Профиль',
                    subtitle: 'Твой вклад в развитие города',
                  ),
                  const SizedBox(height: 16),

                  _HeroProfileCard(
                    name: user.name,
                    district: user.district,
                    level: level,
                    levelName: levelName,
                    totalExp: user.totalExp,
                    streak: user.streak,
                  ),

                  const SizedBox(height: 16),

                  _ProgressOverviewCard(
                    totalReports: user.totalReports,
                    confirmedReports: user.confirmedReports,
                    resolvedReports: user.resolvedReports,
                    resolvedPercent: resolvedPercent,
                    unlockedAchievements: unlockedAchievements,
                    totalAchievements: state.achievements.length,
                  ),

                  const SizedBox(height: 24),

                  const _SectionHeader(
                    title: 'Статистика',
                    subtitle: 'Ключевые показатели активности',
                    compact: true,
                  ),
                  const SizedBox(height: 12),

                  _StatsPanel(
                    totalReports: user.totalReports,
                    confirmedReports: user.confirmedReports,
                    resolvedReports: user.resolvedReports,
                    streak: user.streak,
                  ),

                  const SizedBox(height: 24),

                  _ImpactCard(
                    totalReports: user.totalReports,
                    resolvedReports: user.resolvedReports,
                    confirmedReports: user.confirmedReports,
                  ),

                  const SizedBox(height: 24),

                  _AchievementsHeader(
                    unlocked: unlockedAchievements,
                    total: state.achievements.length,
                  ),
                  const SizedBox(height: 12),

                  ...state.achievements.map(
                    (achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AchievementCard(achievement: achievement),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool compact;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: compact ? 20 : 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _HeroProfileCard extends StatelessWidget {
  final String name;
  final String district;
  final int level;
  final String levelName;
  final int totalExp;
  final int streak;

  const _HeroProfileCard({
    required this.name,
    required this.district,
    required this.level,
    required this.levelName,
    required this.totalExp,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF182338),
            Color(0xFF111827),
            Color(0xFF0B1220),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.12),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBlue.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -25,
            left: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.expPurple.withOpacity(0.10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    LevelBadge(exp: totalExp, size: 82),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _InfoChip(
                                icon: Icons.bolt_rounded,
                                text: 'LV $level • $levelName',
                                color: AppTheme.expPurple,
                              ),
                              _InfoChip(
                                icon: Icons.location_on_rounded,
                                text: district,
                                color: AppTheme.primaryBlue,
                              ),
                              _InfoChip(
                                icon: Icons.local_fire_department_rounded,
                                text: '$streak дн. подряд',
                                color: AppTheme.accentOrange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: AppTheme.expPurple,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Прогресс уровня',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ExpBar(currentExp: totalExp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withOpacity(0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressOverviewCard extends StatelessWidget {
  final int totalReports;
  final int confirmedReports;
  final int resolvedReports;
  final int resolvedPercent;
  final int unlockedAchievements;
  final int totalAchievements;

  const _ProgressOverviewCard({
    required this.totalReports,
    required this.confirmedReports,
    required this.resolvedReports,
    required this.resolvedPercent,
    required this.unlockedAchievements,
    required this.totalAchievements,
  });

  @override
  Widget build(BuildContext context) {
    final confirmationPercent = totalReports == 0
        ? 0
        : ((confirmedReports / totalReports) * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Общий прогресс',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Насколько полезны и результативны твои репорты',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ProgressMetric(
                  title: 'Подтверждение',
                  value: '$confirmationPercent%',
                  color: AppTheme.primaryBlue,
                  progress: confirmationPercent / 100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProgressMetric(
                  title: 'Решаемость',
                  value: '$resolvedPercent%',
                  color: AppTheme.accentGreen,
                  progress: resolvedPercent / 100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProgressMetric(
                  title: 'Ачивки',
                  value: '$unlockedAchievements/$totalAchievements',
                  color: AppTheme.accentOrange,
                  progress: totalAchievements == 0
                      ? 0
                      : unlockedAchievements / totalAchievements,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double progress;

  const _ProgressMetric({
    required this.title,
    required this.value,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  final int totalReports;
  final int confirmedReports;
  final int resolvedReports;
  final int streak;

  const _StatsPanel({
    required this.totalReports,
    required this.confirmedReports,
    required this.resolvedReports,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          _StatRow(
            icon: Icons.flag_rounded,
            iconColor: AppTheme.primaryBlue,
            title: 'Всего репортов',
            subtitle: 'Все отправленные заявки',
            value: '$totalReports',
          ),
          _PanelDivider(),
          _StatRow(
            icon: Icons.verified_rounded,
            iconColor: AppTheme.accentGreen,
            title: 'Подтверждено',
            subtitle: 'Прошли модерацию',
            value: '$confirmedReports',
          ),
          _PanelDivider(),
          _StatRow(
            icon: Icons.task_alt_rounded,
            iconColor: AppTheme.goldColor,
            title: 'Решено',
            subtitle: 'Проблемы устранены',
            value: '$resolvedReports',
          ),
          _PanelDivider(),
          _StatRow(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppTheme.accentOrange,
            title: 'Серия активности',
            subtitle: 'Дней подряд без пропуска',
            value: '$streak',
            valueSuffix: 'дн.',
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String value;
  final String? valueSuffix;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    this.valueSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (valueSuffix != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    valueSuffix!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PanelDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Colors.white.withOpacity(0.05),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final int totalReports;
  final int resolvedReports;
  final int confirmedReports;

  const _ImpactCard({
    required this.totalReports,
    required this.resolvedReports,
    required this.confirmedReports,
  });

  @override
  Widget build(BuildContext context) {
    String impactText;
    if (resolvedReports >= 10) {
      impactText = 'Сильный вклад в улучшение городской среды';
    } else if (resolvedReports >= 5) {
      impactText = 'Хороший результат, город реально меняется';
    } else if (confirmedReports >= 3) {
      impactText = 'Хороший старт, администрация уже видит твои репорты';
    } else if (totalReports >= 1) {
      impactText = 'Первые шаги сделаны — продолжай в том же духе';
    } else {
      impactText = 'Пока нет активности — время сделать первый репорт';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withOpacity(0.18),
            AppTheme.expPurple.withOpacity(0.12),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Твой эффект',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  impactText,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsHeader extends StatelessWidget {
  final int unlocked;
  final int total;

  const _AchievementsHeader({
    required this.unlocked,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _SectionHeader(
            title: 'Достижения',
            subtitle: 'Открывай ачивки за полезные действия',
            compact: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.accentGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppTheme.accentGreen.withOpacity(0.16),
            ),
          ),
          child: Text(
            '$unlocked / $total',
            style: const TextStyle(
              color: AppTheme.accentGreen,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}