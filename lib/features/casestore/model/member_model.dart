class MemberModel {
    MemberModel({
        required this.id,
        required this.sessionId,
        required this.userId,
        required this.userName,
        required this.userEmail,
        required this.role,
        required this.status,
        required this.individualScore,
        required this.joinedAt,
    });

    final String? id;
    final String? sessionId;
    final String? userId;
    final String? userName;
    final dynamic userEmail;
    final String? role;
    final String? status;
    final int? individualScore;
    final DateTime? joinedAt;

    MemberModel copyWith({
        String? id,
        String? sessionId,
        String? userId,
        String? userName,
        dynamic? userEmail,
        String? role,
        String? status,
        int? individualScore,
        DateTime? joinedAt,
    }) {
        return MemberModel(
            id: id ?? this.id,
            sessionId: sessionId ?? this.sessionId,
            userId: userId ?? this.userId,
            userName: userName ?? this.userName,
            userEmail: userEmail ?? this.userEmail,
            role: role ?? this.role,
            status: status ?? this.status,
            individualScore: individualScore ?? this.individualScore,
            joinedAt: joinedAt ?? this.joinedAt,
        );
    }

    factory MemberModel.fromJson(Map<String, dynamic> json){ 
        return MemberModel(
            id: json["id"],
            sessionId: json["sessionId"],
            userId: json["userId"],
            userName: json["userName"],
            userEmail: json["userEmail"],
            role: json["role"],
            status: json["status"],
            individualScore: json["individualScore"],
            joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "sessionId": sessionId,
        "userId": userId,
        "userName": userName,
        "userEmail": userEmail,
        "role": role,
        "status": status,
        "individualScore": individualScore,
        "joinedAt": joinedAt?.toIso8601String(),
    };

}
