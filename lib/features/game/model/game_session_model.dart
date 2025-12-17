class GameSessionModel {
    GameSessionModel({
        required this.id,
        required this.gameId,
        required this.creatorId,
        required this.sessionCode,
        required this.mode,
        required this.status,
        required this.maxPlayers,
        required this.currentPlayers,
        required this.language,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? gameId;
    final String? creatorId;
    final String? sessionCode;
    final String? mode;
    final String? status;
    final int? maxPlayers;
    final int? currentPlayers;
    final String? language;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory GameSessionModel.fromJson(Map<String, dynamic> json){ 
        return GameSessionModel(
            id: json["id"],
            gameId: json["gameId"],
            creatorId: json["creatorId"],
            sessionCode: json["sessionCode"],
            mode: json["mode"],
            status: json["status"],
            maxPlayers: json["maxPlayers"],
            currentPlayers: json["currentPlayers"],
            language: json["language"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

    GameSessionModel copyWith({
      String? id,
      String? gameId,
      String? creatorId,
      String? sessionCode,
      String? mode,
      String? status,
      int? maxPlayers,
      int? currentPlayers,
      String? language,
      DateTime? createdAt,
      DateTime? updatedAt,
    }) {
      return GameSessionModel(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        creatorId: creatorId ?? this.creatorId,
        sessionCode: sessionCode ?? this.sessionCode,
        mode: mode ?? this.mode,
        status: status ?? this.status,
        maxPlayers: maxPlayers ?? this.maxPlayers,
        currentPlayers: currentPlayers ?? this.currentPlayers,
        language: language ?? this.language,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "gameId": gameId,
        "creatorId": creatorId,
        "sessionCode": sessionCode,
        "mode": mode,
        "status": status,
        "maxPlayers": maxPlayers,
        "currentPlayers": currentPlayers,
        "language": language,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };

}
