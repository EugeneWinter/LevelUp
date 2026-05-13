// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final districts = [
      _DistrictData('Центральный', 4820, 156, true),
      _DistrictData('Северо-Задонск', 3910, 132, false),
      _DistrictData('Подлесный', 3540, 98, false),
      _DistrictData('Руднев', 2870, 87, false),
      _DistrictData('Бобрик-Гора', 2340, 72, false),
      _DistrictData('Новоугольный', 1950, 58, false),
    ];

    final topUsers = [
      _UserData('Евгений З.', 'Центральный', 350, 7, 2),
      _UserData('Алексей М.', 'Центральный', 1280, 24, 1),
      _UserData('Мария К.', 'Северо-Задонск', 890, 18, 3),
      _UserData('Дмитрий П.', 'Подлесный', 720, 15, 4),
      _UserData('Анна В.', 'Руднев', 540, 11, 5),
      _UserData('Игорь С.', 'Бобрик-Гора', 430, 9, 6),
      _UserData('Ольга Н.', 'Центральный', 380, 8, 7),
      _UserData('Павел Р.', 'Новоугольный', 290, 6, 8),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Рейтинг',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Соревнуйся с районами и жителями',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Districts section
            const Row(
              children: [
                Icon(Icons.location_city,
                    color: AppTheme.primaryBlue, size: 22),
                SizedBox(width: 8),
                Text(
                  'Рейтинг районов',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...districts.asMap().entries.map((entry) {
              int index = entry.key;
              var district = entry.value;
              return _DistrictCard(
                rank: index + 1,
                data: district,
              );
            }),

            const SizedBox(height: 28),

            // Top users section
            const Row(
              children: [
                Icon(Icons.people,
                    color: AppTheme.accentGreen, size: 22),
                SizedBox(width: 8),
                Text(
                  'Топ жителей',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...topUsers.map((userData) {
              return _UserCard(data: userData);
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _DistrictData {
  final String name;
  final int totalExp;
  final int reports;
  final bool isUserDistrict;

  _DistrictData(
      this.name, this.totalExp, this.reports, this.isUserDistrict);
}

class _UserData {
  final String name;
  final String district;
  final int exp;
  final int reports;
  final int rank;

  _UserData(
      this.name, this.district, this.exp, this.reports, this.rank);
}

class _DistrictCard extends StatelessWidget {
  final int rank;
  final _DistrictData data;

  const _DistrictCard({required this.rank, required this.data});

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    switch (rank) {
      case 1:
        rankColor = AppTheme.goldColor;
        break;
      case 2:
        rankColor = Colors.grey.shade400;
        break;
      case 3:
        rankColor = Colors.brown.shade400;
        break;
      default:
        rankColor = AppTheme.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.isUserDistrict
            ? AppTheme.primaryBlue.withOpacity(0.1)
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.isUserDistrict
              ? AppTheme.primaryBlue.withOpacity(0.3)
              : AppTheme.surfaceLight,
          width: data.isUserDistrict ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (data.isUserDistrict) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.primaryBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Ваш район',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${data.reports} репортов',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${data.totalExp}',
            style: TextStyle(
              color: rankColor,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'EXP',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final _UserData data;

  const _UserCard({required this.data});

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = data.name == 'Евгений З.';

    Color rankColor;
    switch (data.rank) {
      case 1:
        rankColor = AppTheme.goldColor;
        break;
      case 2:
        rankColor = Colors.grey.shade400;
        break;
      case 3:
        rankColor = Colors.brown.shade400;
        break;
      default:
        rankColor = AppTheme.textSecondary;
    }

    String rankEmoji = '';
    if (data.rank == 1) rankEmoji = ' 🥇';
    if (data.rank == 2) rankEmoji = ' 🥈';
    if (data.rank == 3) rankEmoji = ' 🥉';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.accentGreen.withOpacity(0.08)
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentUser
              ? AppTheme.accentGreen.withOpacity(0.3)
              : AppTheme.surfaceLight,
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${data.rank}',
                style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${data.name}$rankEmoji',
                      style: TextStyle(
                        color: isCurrentUser
                            ? AppTheme.accentGreen
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      const Text(
                        '(вы)',
                        style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${data.district} • ${data.reports} репортов',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${data.exp}',
            style: TextStyle(
              color: isCurrentUser
                  ? AppTheme.accentGreen
                  : AppTheme.expPurple,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
      
      
          ),
          const SizedBox(width: 3),
          const Text(
            'EXP',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}