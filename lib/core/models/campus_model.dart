class CampusModel {
  final String id;
  final String? campusName;
  final String? address;
  final DateTime createdAt;

  const CampusModel({
    required this.id,
    this.campusName,
    this.address,
    required this.createdAt,
  });

  factory CampusModel.fromJson(Map<String, dynamic> json) {
    return CampusModel(
      id: json['id'] as String,
      campusName: json['campus_name'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campus_name': campusName,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
