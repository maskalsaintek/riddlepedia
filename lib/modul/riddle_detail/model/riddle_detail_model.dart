class RiddleDetail {
  final int id;
  final String title;
  final String description;
  final String answer;
  final String difficulty;
  final String hint1;
  final String hint2;
  final String hint3;
  final double rating;
  final int categoryId;
  final String categoryName;
  final String authorFullName;
  final List<String> options;

  RiddleDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.answer,
    required this.difficulty,
    required this.hint1,
    required this.hint2,
    required this.hint3,
    required this.rating,
    required this.categoryId,
    required this.categoryName,
    required this.authorFullName,
    required this.options,
  });

  factory RiddleDetail.fromJson(Map<String, dynamic> json) {
    return RiddleDetail(
      id: json['riddle_id'],
      title: json['riddle_title'],
      description: json['riddle_description'],
      answer: json['riddle_answer'],
      difficulty: json['riddle_difficulty'],
      hint1: json['riddle_hint1'],
      hint2: json['riddle_hint2'],
      hint3: json['riddle_hint3'],
      rating: double.parse(json["riddle_rating"].toString()),
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      authorFullName: json['author_name'],
      options: [
        json['option1'],
        json['option2'],
        json['option3'],
        json['option4'],
      ],
    );
  }
}
