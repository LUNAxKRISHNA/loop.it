class RoleModel {
  final String id;
  final String? roleName;
  final DateTime createdAt;

  const RoleModel({
    required this.id,
    this.roleName,
    required this.createdAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String,
      roleName: json['role_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_name': roleName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
