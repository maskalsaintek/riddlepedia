class CompetitionRanking {
  final String email;
  final String fullName;
  final int totalScore;

  CompetitionRanking({
    required this.email,
    required this.fullName,
    required this.totalScore
  });

  factory CompetitionRanking.fromJson(Map<String, dynamic> json) {
    return CompetitionRanking(
      email: json['email'],
      fullName: json['full_name'],
      totalScore: json['total_score']
    );
  }
}
