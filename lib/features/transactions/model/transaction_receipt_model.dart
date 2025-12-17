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
    final int? points;
    final int? price;
    final String? currency;
    final String? description;
    final DateTime? createdAt;
    final String? referenceId;
    final String? status;

    TransactionReceiptModel copyWith({
        String? id,
        String? type,
        int? points,
        int? price,
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

    factory TransactionReceiptModel.fromJson(Map<String, dynamic> json){ 
        return TransactionReceiptModel(
            id: json["id"],
            type: json["type"],
            points: json["points"],
            price: json["price"],
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

}
