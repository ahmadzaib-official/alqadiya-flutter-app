class TransactionModel {
    TransactionModel({
        required this.id,
        required this.type,
        required this.points,
        required this.price,
        required this.currency,
        required this.description,
        required this.createdAt,
        required this.referenceId,
    });

    final String? id;
    final String? type;
    final int? points;
    final int? price;
    final String? currency;
    final String? description;
    final DateTime? createdAt;
    final String? referenceId;

    TransactionModel copyWith({
        String? id,
        String? type,
        int? points,
        int? price,
        String? currency,
        String? description,
        DateTime? createdAt,
        String? referenceId,
    }) {
        return TransactionModel(
            id: id ?? this.id,
            type: type ?? this.type,
            points: points ?? this.points,
            price: price ?? this.price,
            currency: currency ?? this.currency,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            referenceId: referenceId ?? this.referenceId,
        );
    }

    factory TransactionModel.fromJson(Map<String, dynamic> json){ 
        return TransactionModel(
            id: json["id"],
            type: json["type"],
            points: json["points"],
            price: json["price"],
            currency: json["currency"],
            description: json["description"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            referenceId: json["referenceId"],
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
    };

}
