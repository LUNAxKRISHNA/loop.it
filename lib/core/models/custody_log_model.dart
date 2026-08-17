class CustodyLogModel {
  final String id;
  final String dispatchId;
  final String? previousHolderId;
  final String newHolderId;
  final String? previousCampusId;
  final String? newCampusId;
  final String statusAtTransfer;
  final String? remarks;
  final DateTime transferredAt;

  const CustodyLogModel({
    required this.id,
    required this.dispatchId,
    this.previousHolderId,
    required this.newHolderId,
    this.previousCampusId,
    this.newCampusId,
    required this.statusAtTransfer,
    this.remarks,
    required this.transferredAt,
  });

  factory CustodyLogModel.fromJson(Map<String, dynamic> json) {
    return CustodyLogModel(
      id: json['id'] as String,
      dispatchId: json['dispatch_id'] as String,
      previousHolderId: json['previous_holder_id'] as String?,
      newHolderId: json['new_holder_id'] as String,
      previousCampusId: json['previous_campus_id'] as String?,
      newCampusId: json['new_campus_id'] as String?,
      statusAtTransfer: json['status_at_transfer'] as String,
      remarks: json['remarks'] as String?,
      transferredAt: DateTime.parse(json['transferred_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dispatch_id': dispatchId,
      'previous_holder_id': previousHolderId,
      'new_holder_id': newHolderId,
      'previous_campus_id': previousCampusId,
      'new_campus_id': newCampusId,
      'status_at_transfer': statusAtTransfer,
      'remarks': remarks,
      'transferred_at': transferredAt.toIso8601String(),
    };
  }
}
