class PackageModel {
    PackageModel({
        required this.id,
        required this.points,
        required this.price,
        required this.currency,
        required this.isActive,
        required this.order,
    });

    final String? id;
    final int? points;
    final int? price;
    final String? currency;
    final bool? isActive;
    final int? order;

    PackageModel copyWith({
        String? id,
        int? points,
        int? price,
        String? currency,
        bool? isActive,
        int? order,
    }) {
        return PackageModel(
            id: id ?? this.id,
            points: points ?? this.points,
            price: price ?? this.price,
            currency: currency ?? this.currency,
            isActive: isActive ?? this.isActive,
            order: order ?? this.order,
        );
    }

    factory PackageModel.fromJson(Map<String, dynamic> json){ 
        return PackageModel(
            id: json["id"],
            points: json["points"],
            price: json["price"],
            currency: json["currency"],
            isActive: json["isActive"],
            order: json["order"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "points": points,
        "price": price,
        "currency": currency,
        "isActive": isActive,
        "order": order,
    };

}
