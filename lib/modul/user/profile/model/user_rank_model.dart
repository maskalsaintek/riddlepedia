class UserRank {
  final int id;
  final String email;
  final String fullName;
  final int totalScore;
  final int rank;

  UserRank({
    required this.id,
    required this.email,
    required this.fullName,
    required this.totalScore,
    required this.rank
  });

  factory UserRank.fromJson(Map<String, dynamic> json) {
    return UserRank(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      totalScore: json['total_score'],
      rank: json['rank']
    );
  }
}
