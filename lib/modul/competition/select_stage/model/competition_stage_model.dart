class CompetitionStage {
  final bool hasEntry;
  final int riddleId;

  CompetitionStage({
    required this.hasEntry,
    required this.riddleId
  });

  factory CompetitionStage.fromJson(Map<String, dynamic> json) {
    return CompetitionStage(
      hasEntry: json['has_entry'],
      riddleId: json['riddle_id']
    );
  }
}
