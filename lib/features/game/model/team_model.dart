class TeamModel {
    TeamModel({
        required this.id,
        required this.sessionId,
        required this.teamName,
        required this.teamNumber,
        required this.leaderUserId,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? sessionId;
    final String? teamName;
    final int? teamNumber;
    final dynamic leaderUserId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    TeamModel copyWith({
        String? id,
        String? sessionId,
        String? teamName,
        int? teamNumber,
        dynamic? leaderUserId,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return TeamModel(
            id: id ?? this.id,
            sessionId: sessionId ?? this.sessionId,
            teamName: teamName ?? this.teamName,
            teamNumber: teamNumber ?? this.teamNumber,
            leaderUserId: leaderUserId ?? this.leaderUserId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory TeamModel.fromJson(Map<String, dynamic> json){ 
        return TeamModel(
            id: json["id"],
            sessionId: json["sessionId"],
            teamName: json["teamName"],
            teamNumber: json["teamNumber"],
            leaderUserId: json["leaderUserId"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "sessionId": sessionId,
        "teamName": teamName,
        "teamNumber": teamNumber,
        "leaderUserId": leaderUserId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };

}
