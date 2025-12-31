class ScoreboardModel {
  ScoreboardModel({
    this.sessionId,
    this.caseName,
    this.remainingTime,
    this.teams,
    this.players,
  });

  final String? sessionId;
  final String? caseName;
  final String? remainingTime;
  final List<TeamScore>? teams;
  final List<PlayerScore>? players;

  factory ScoreboardModel.fromJson(Map<String, dynamic> json) {
    return ScoreboardModel(
      sessionId: json["sessionId"],
      caseName: json["caseName"],
      remainingTime: json["remainingTime"],
      teams: json["teams"] != null
          ? (json["teams"] as List)
              .map((e) => TeamScore.fromJson(e))
              .toList()
          : null,
      players: json["players"] != null
          ? (json["players"] as List)
              .map((e) => PlayerScore.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "caseName": caseName,
    "remainingTime": remainingTime,
    "teams": teams?.map((e) => e.toJson()).toList(),
    "players": players?.map((e) => e.toJson()).toList(),
  };
}

class TeamScore {
  TeamScore({
    this.teamId,
    this.teamName,
    this.teamNumber,
    this.teamScore,
    this.players,
  });

  final String? teamId;
  final String? teamName;
  final int? teamNumber;
  final int? teamScore;
  final List<PlayerScore>? players;

  factory TeamScore.fromJson(Map<String, dynamic> json) {
    return TeamScore(
      teamId: json["teamId"],
      teamName: json["teamName"],
      teamNumber: json["teamNumber"],
      teamScore: json["teamScore"] ?? 0,
      players: json["players"] != null
          ? (json["players"] as List)
              .map((e) => PlayerScore.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "teamId": teamId,
    "teamName": teamName,
    "teamNumber": teamNumber,
    "teamScore": teamScore,
    "players": players?.map((e) => e.toJson()).toList(),
  };
}

class PlayerScore {
  PlayerScore({
    this.userId,
    this.userName,
    this.individualScore,
  });

  final String? userId;
  final String? userName;
  final int? individualScore;

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore(
      userId: json["userId"],
      userName: json["userName"],
      individualScore: json["individualScore"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "individualScore": individualScore,
  };
}

