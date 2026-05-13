class UserProfile {
  final String name;
  final String district;
  final int totalExp;
  final int totalReports;
  final int confirmedReports;
  final int resolvedReports;
  final int streak;
  final DateTime joinedAt;

  UserProfile({
    required this.name,
    this.district = 'Центральный',
    this.totalExp = 0,
    this.totalReports = 0,
    this.confirmedReports = 0,
    this.resolvedReports = 0,
    this.streak = 0,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  UserProfile copyWith({
    String? name,
    String? district,
    int? totalExp,
    int? totalReports,
    int? confirmedReports,
    int? resolvedReports,
    int? streak,
  }) {
    return UserProfile(
      name: name ?? this.name,
      district: district ?? this.district,
      totalExp: totalExp ?? this.totalExp,
      totalReports: totalReports ?? this.totalReports,
      confirmedReports: confirmedReports ?? this.confirmedReports,
      resolvedReports: resolvedReports ?? this.resolvedReports,
      streak: streak ?? this.streak,
      joinedAt: joinedAt,
    );
  }
}