class GameResultModel {
  GameResultModel({
    this.sessionId,
    this.caseName,
    this.gameDisplayId,
    this.teams,
    this.players,
    this.winnerTeamId,
    this.winnerTeamName,
    this.completedAt,
  });

  final String? sessionId;
  final String? caseName;
  final String? gameDisplayId;
  final List<TeamResult>? teams;
  final List<PlayerResult>? players;
  final String? winnerTeamId;
  final String? winnerTeamName;
  final DateTime? completedAt;

  factory GameResultModel.fromJson(Map<String, dynamic> json) {
    return GameResultModel(
      sessionId: json["sessionId"],
      caseName: json["caseName"],
      gameDisplayId: json["gameDisplayId"],
      teams:
          json["teams"] != null
              ? (json["teams"] as List)
                  .map((e) => TeamResult.fromJson(e))
                  .toList()
              : null,
      players:
          json["players"] != null
              ? (json["players"] as List)
                  .map((e) => PlayerResult.fromJson(e))
                  .toList()
              : null,
      winnerTeamId: json["winnerTeamId"],
      winnerTeamName: json["winnerTeamName"],
      completedAt: DateTime.tryParse(json["completedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "caseName": caseName,
    "gameDisplayId": gameDisplayId,
    "teams": teams?.map((e) => e.toJson()).toList(),
    "players": players?.map((e) => e.toJson()).toList(),
    "winnerTeamId": winnerTeamId,
    "winnerTeamName": winnerTeamName,
    "completedAt": completedAt?.toIso8601String(),
  };
}

class TeamResult {
  TeamResult({
    this.teamId,
    this.teamName,
    this.leaderName,
    this.leaderPhotoURL,
    this.members,
    this.suspectChosenName,
    this.totalScore,
    this.timeTaken,
    this.accuracy,
    this.hintsUsed,
    this.questionsAnswered,
    this.totalQuestions,
  });

  final String? teamId;
  final String? teamName;
  final String? leaderName;
  final String? leaderPhotoURL;
  final List<TeamMember>? members;
  final String? suspectChosenName;
  final int? totalScore;
  final String? timeTaken;
  final int? accuracy;
  final int? hintsUsed;
  final int? questionsAnswered;
  final int? totalQuestions;

  factory TeamResult.fromJson(Map<String, dynamic> json) {
    return TeamResult(
      teamId: json["teamId"],
      teamName: json["teamName"],
      leaderName: json["leaderName"],
      leaderPhotoURL: json["leaderPhotoURL"],
      members:
          json["members"] != null
              ? (json["members"] as List)
                  .map((e) => TeamMember.fromJson(e))
                  .toList()
              : null,
      suspectChosenName: json["suspectChosenName"],
      totalScore: json["totalScore"] ?? 0,
      timeTaken: json["timeTaken"],
      accuracy: json["accuracy"] ?? 0,
      hintsUsed: json["hintsUsed"] ?? 0,
      questionsAnswered: json["questionsAnswered"] ?? 0,
      totalQuestions: json["totalQuestions"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "teamId": teamId,
    "teamName": teamName,
    "leaderName": leaderName,
    "leaderPhotoURL": leaderPhotoURL,
    "members": members?.map((e) => e.toJson()).toList(),
    "suspectChosenName": suspectChosenName,
    "totalScore": totalScore,
    "timeTaken": timeTaken,
    "accuracy": accuracy,
    "hintsUsed": hintsUsed,
    "questionsAnswered": questionsAnswered,
    "totalQuestions": totalQuestions,
  };
}

class TeamMember {
  TeamMember({this.id, this.userId, this.name, this.photoURL, this.isLeader});

  final String? id;
  final String? userId;
  final String? name;
  final String? photoURL;
  final bool? isLeader;

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      photoURL: json["photoURL"],
      isLeader: json["isLeader"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
    "photoURL": photoURL,
    "isLeader": isLeader,
  };
}

class PlayerResult {
  PlayerResult({
    this.userId,
    this.userName,
    this.suspectChosenName,
    this.totalScore,
    this.timeTaken,
    this.accuracy,
    this.hintsUsed,
    this.questionsAnswered,
    this.totalQuestions,
  });

  final String? userId;
  final String? userName;
  final String? suspectChosenName;
  final int? totalScore;
  final String? timeTaken;
  final int? accuracy;
  final int? hintsUsed;
  final int? questionsAnswered;
  final int? totalQuestions;

  factory PlayerResult.fromJson(Map<String, dynamic> json) {
    return PlayerResult(
      userId: json["userId"],
      userName: json["userName"],
      suspectChosenName: json["suspectChosenName"],
      totalScore: json["totalScore"] ?? 0,
      timeTaken: json["timeTaken"],
      accuracy: json["accuracy"] ?? 0,
      hintsUsed: json["hintsUsed"] ?? 0,
      questionsAnswered: json["questionsAnswered"] ?? 0,
      totalQuestions: json["totalQuestions"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "suspectChosenName": suspectChosenName,
    "totalScore": totalScore,
    "timeTaken": timeTaken,
    "accuracy": accuracy,
    "hintsUsed": hintsUsed,
    "questionsAnswered": questionsAnswered,
    "totalQuestions": totalQuestions,
  };
}
