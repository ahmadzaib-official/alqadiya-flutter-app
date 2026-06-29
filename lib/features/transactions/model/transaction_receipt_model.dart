class TransactionReceiptModel {
  TransactionReceiptModel({
    required this.id,
    required this.type,
    required this.points,
    required this.price,
    required this.currency,
    required this.description,
    required this.createdAt,
    required this.referenceId,
    required this.status,
  });

  final String? id;
  final String? type;
  final num? points;
  final double? price;
  final String? currency;
  final String? description;
  final DateTime? createdAt;
  final String? referenceId;
  final String? status;

  TransactionReceiptModel copyWith({
    String? id,
    String? type,
    num? points,
    double? price,
    String? currency,
    String? description,
    DateTime? createdAt,
    String? referenceId,
    String? status,
  }) {
    return TransactionReceiptModel(
      id: id ?? this.id,
      type: type ?? this.type,
      points: points ?? this.points,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      referenceId: referenceId ?? this.referenceId,
      status: status ?? this.status,
    );
  }

  factory TransactionReceiptModel.fromJson(Map<String, dynamic> json) {
    return TransactionReceiptModel(
      id: json["id"],
      type: json["type"],
      points: json["points"] is num ? (json["points"] as num) : null,
      price: json["price"] is num ? (json["price"] as num).toDouble() : null,
      currency: json["currency"],
      description: json["description"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      referenceId: json["referenceId"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "points": points,
    "price": price,
    "currency": currency,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "referenceId": referenceId,
    "status": status,
  };

  /// Get formatted points display string
  String get formattedPoints {
    if (points == null) return "0";
    // If it's a whole number, display as integer, otherwise show decimal
    if (points! % 1 == 0) {
      return points!.toInt().toString();
    }
    return points!.toString();
  }
}
