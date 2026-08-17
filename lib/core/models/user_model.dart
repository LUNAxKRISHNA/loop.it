class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? roleId;
  final String? campusId;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.roleId,
    this.campusId,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      roleId: json['role_id'] as String?,
      campusId: json['campus_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role_id': roleId,
      'campus_id': campusId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? roleId,
    String? campusId,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
      campusId: campusId ?? this.campusId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
