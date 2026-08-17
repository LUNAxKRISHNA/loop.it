enum DispatchStatus {
  pending,
  collectedSource,
  inTransit,
  arrivedDestination,
  completed,
  returned,
  cancelled;

  /// Converts database string to enum
  static DispatchStatus fromString(String value) {
    return switch (value) {
      'pending' => DispatchStatus.pending,
      'collected_source' => DispatchStatus.collectedSource,
      'in_transit' => DispatchStatus.inTransit,
      'arrived_destination' => DispatchStatus.arrivedDestination,
      'completed' => DispatchStatus.completed,
      'returned' => DispatchStatus.returned,
      'cancelled' => DispatchStatus.cancelled,
      _ => DispatchStatus.pending,
    };
  }

  /// Converts enum to database string
  String toDbString() {
    return switch (this) {
      DispatchStatus.pending => 'pending',
      DispatchStatus.collectedSource => 'collected_source',
      DispatchStatus.inTransit => 'in_transit',
      DispatchStatus.arrivedDestination => 'arrived_destination',
      DispatchStatus.completed => 'completed',
      DispatchStatus.returned => 'returned',
      DispatchStatus.cancelled => 'cancelled',
    };
  }

  String get displayLabel {
    return switch (this) {
      DispatchStatus.pending => 'Pending',
      DispatchStatus.collectedSource => 'Collected at Source',
      DispatchStatus.inTransit => 'In Transit',
      DispatchStatus.arrivedDestination => 'Arrived at Destination',
      DispatchStatus.completed => 'Completed',
      DispatchStatus.returned => 'Returned',
      DispatchStatus.cancelled => 'Cancelled',
    };
  }
}

class DispatchModel {
  final String id;
  final String? dispatchNo;
  final String? title;
  final String? description;
  final String? itemType;
  final String? priority;
  final String? senderId;
  final String? receiverName;
  final String? receiverPhone;
  final String? receiverEmail;
  final String? sourceCampusId;
  final String? destinationCampusId;
  final DispatchStatus status;
  final String? remarks;
  final DateTime? completedAt;
  final DateTime createdAt;
  final String? currentHolderId;
  final String? currentHolderName;
  final String? currentCampusId;
  final String? qrToken;
  final DateTime? qrTokenExpiresAt;

  const DispatchModel({
    required this.id,
    this.dispatchNo,
    this.title,
    this.description,
    this.itemType,
    this.priority,
    this.senderId,
    this.receiverName,
    this.receiverPhone,
    this.receiverEmail,
    this.sourceCampusId,
    this.destinationCampusId,
    required this.status,
    this.remarks,
    this.completedAt,
    required this.createdAt,
    this.currentHolderId,
    this.currentHolderName,
    this.currentCampusId,
    this.qrToken,
    this.qrTokenExpiresAt,
  });

  factory DispatchModel.fromJson(Map<String, dynamic> json) {
    return DispatchModel(
      id: json['id'] as String,
      dispatchNo: json['dispatch_no'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      itemType: json['item_type'] as String?,
      priority: json['priority'] as String?,
      senderId: json['sender_id'] as String?,
      receiverName: json['receiver_name'] as String?,
      receiverPhone: json['receiver_phone'] as String?,
      receiverEmail: json['receiver_email'] as String?,
      sourceCampusId: json['source_campus_id'] as String?,
      destinationCampusId: json['destination_campus_id'] as String?,
      status: DispatchStatus.fromString(json['status'] as String? ?? 'pending'),
      remarks: json['remarks'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      currentHolderId: json['current_holder_id'] as String?,
      currentHolderName: json['current_holder_name'] as String?,
      currentCampusId: json['current_campus_id'] as String?,
      qrToken: json['qr_token'] as String?,
      qrTokenExpiresAt: json['qr_token_expires_at'] != null
          ? DateTime.parse(json['qr_token_expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dispatch_no': dispatchNo,
      'title': title,
      'description': description,
      'item_type': itemType,
      'priority': priority,
      'sender_id': senderId,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'receiver_email': receiverEmail,
      'source_campus_id': sourceCampusId,
      'destination_campus_id': destinationCampusId,
      'status': status.toDbString(),
      'remarks': remarks,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'current_holder_id': currentHolderId,
      'current_holder_name': currentHolderName,
      'current_campus_id': currentCampusId,
      'qr_token': qrToken,
      'qr_token_expires_at': qrTokenExpiresAt?.toIso8601String(),
    };
  }

  /// Returns only the fields needed when creating a new dispatch
  Map<String, dynamic> toInsertJson() {
    return {
      'title': title,
      'description': description,
      'item_type': itemType,
      'priority': priority,
      'sender_id': senderId,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'receiver_email': receiverEmail,
      'source_campus_id': sourceCampusId,
      'destination_campus_id': destinationCampusId,
      'remarks': remarks,
      'current_holder_id': senderId,
      'current_holder_name': currentHolderName,
      'current_campus_id': sourceCampusId,
    };
  }

  bool get isQrTokenValid {
    if (qrToken == null || qrTokenExpiresAt == null) return false;
    return DateTime.now().isBefore(qrTokenExpiresAt!);
  }

  bool get isAtDestination => currentCampusId == destinationCampusId;
}
