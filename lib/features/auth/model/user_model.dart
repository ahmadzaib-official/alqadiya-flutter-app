class UserModel {
    UserModel({
        required this.id,
        required this.fullName,
        required this.role,
        required this.email,
        required this.callingCode,
        required this.photoId,
        required this.photoUrl,
        required this.phoneNumber,
        required this.countryCode,
        required this.status,
        required this.authProvider,
        required this.isPhoneNumberVerified,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? fullName;
    final String? role;
    final String? email;
    final dynamic callingCode;
    final dynamic photoId;
    final dynamic photoUrl;
    final dynamic phoneNumber;
    final dynamic countryCode;
    final String? status;
    final String? authProvider;
    final bool? isPhoneNumberVerified;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            id: json["id"],
            fullName: json["fullName"],
            role: json["role"],
            email: json["email"],
            callingCode: json["callingCode"],
            photoId: json["photoId"],
            photoUrl: json["photoURL"],
            phoneNumber: json["phoneNumber"],
            countryCode: json["countryCode"],
            status: json["status"],
            authProvider: json["authProvider"],
            isPhoneNumberVerified: json["isPhoneNumberVerified"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "role": role,
        "email": email,
        "callingCode": callingCode,
        "photoId": photoId,
        "photoURL": photoUrl,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "status": status,
        "authProvider": authProvider,
        "isPhoneNumberVerified": isPhoneNumberVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };

}
