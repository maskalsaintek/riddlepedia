class RpUser {
  final int id;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String createdBy;
  final String lastUpdateBy;
  final String recordFlag;
  final String email;
  final String password;
  final String fullName;

  RpUser({
    required this.id,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.createdBy,
    required this.lastUpdateBy,
    required this.recordFlag,
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory RpUser.fromJson(Map<String, dynamic> json) {
    return RpUser(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
      createdBy: json['create_by'],
      lastUpdateBy: json['last_update_by'],
      recordFlag: json['record_flag'],
      email: json['email'],
      password: json['password'],
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'last_updated_at': lastUpdatedAt.toIso8601String(),
      'create_by': createdBy,
      'last_update_by': lastUpdateBy,
      'record_flag': recordFlag,
      'email': email,
      'password': password,
      'full_name': fullName,
    };
  }
}
