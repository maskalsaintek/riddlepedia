class Riddle {
  final int id;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String createBy;
  final String lastUpdateBy;
  final String recordFlag;
  final String title;
  final String description;
  final String answer;
  final String difficulty;
  final String type;
  final int authorId;
  final int categoryId;
  final double rating;
  final String hint1;
  final String hint2;
  final String hint3;

  Riddle({
    required this.id,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.createBy,
    required this.lastUpdateBy,
    required this.recordFlag,
    required this.title,
    required this.description,
    required this.answer,
    required this.difficulty,
    required this.type,
    required this.authorId,
    required this.categoryId,
    required this.rating,
    required this.hint1,
    required this.hint2,
    required this.hint3,
  });

  factory Riddle.fromJson(Map<String, dynamic> json) {
    return Riddle(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
      createBy: json['create_by'],
      lastUpdateBy: json['last_update_by'],
      recordFlag: json['record_flag'],
      title: json['title'],
      description: json['description'],
      answer: json['answer'],
      difficulty: json['difficulty'],
      type: json['type'],
      authorId: json['author_id'],
      categoryId: json['category_id'],
      rating: (json['rating'] as num).toDouble(),
      hint1: json['hint1'],
      hint2: json['hint2'],
      hint3: json['hint3'],
    );
  }
}
