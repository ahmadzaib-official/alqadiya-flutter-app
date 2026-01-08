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
    required this.pointsBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? fullName;
  final String? role;
  final String? email;
  final String? callingCode;
  final dynamic photoId;
  final dynamic photoUrl;
  final dynamic phoneNumber;
  final String? countryCode;
  final String? status;
  final String? authProvider;
  final bool? isPhoneNumberVerified;
  final int? pointsBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      fullName: json["fullName"],
      role: json["role"],
      email: json["email"],
      callingCode: json["callingCode"] ?? "+965",
      photoId: json["photoId"],
      photoUrl: json["photoURL"],
      phoneNumber: json["phoneNumber"],
      countryCode: json["countryCode"] ?? "KW",
      status: json["status"],
      authProvider: json["authProvider"],
      isPhoneNumberVerified: json["isPhoneNumberVerified"],
      pointsBalance: json["pointsBalance"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}
