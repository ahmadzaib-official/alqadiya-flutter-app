class PaymentMethodModel {
    PaymentMethodModel({
        required this.id,
        required this.name,
        required this.iconUploadId,
        required this.iconUrl,
        required this.isActive,
        required this.order,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? name;
    final String? iconUploadId;
    final String? iconUrl;
    final bool? isActive;
    final int? order;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    PaymentMethodModel copyWith({
        String? id,
        String? name,
        String? iconUploadId,
        String? iconUrl,
        bool? isActive,
        int? order,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return PaymentMethodModel(
            id: id ?? this.id,
            name: name ?? this.name,
            iconUploadId: iconUploadId ?? this.iconUploadId,
            iconUrl: iconUrl ?? this.iconUrl,
            isActive: isActive ?? this.isActive,
            order: order ?? this.order,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory PaymentMethodModel.fromJson(Map<String, dynamic> json){ 
        return PaymentMethodModel(
            id: json["id"],
            name: json["name"],
            iconUploadId: json["iconUploadId"],
            iconUrl: json["iconUrl"],
            isActive: json["isActive"],
            order: json["order"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUploadId": iconUploadId,
        "iconUrl": iconUrl,
        "isActive": isActive,
        "order": order,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };

}
