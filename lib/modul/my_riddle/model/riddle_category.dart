class RiddleCategory {
  final int id;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String createBy;
  final String lastUpdateBy;
  final String recordFlag;
  final String name;

  RiddleCategory({
    required this.id,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.createBy,
    required this.lastUpdateBy,
    required this.recordFlag,
    required this.name
  });

  factory RiddleCategory.fromJson(Map<String, dynamic> json) {
    return RiddleCategory(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
      createBy: json['create_by'],
      lastUpdateBy: json['last_update_by'],
      recordFlag: json['record_flag'],
      name: json['name']
    );
  }
}
