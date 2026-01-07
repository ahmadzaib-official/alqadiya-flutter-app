// class ScoreboardModel {
//   ScoreboardModel({
//     this.sessionId,
//     this.caseName,
//     this.remainingTime,
//     this.teams,
//     this.players,
//   });

//   final String? sessionId;
//   final String? caseName;
//   final String? remainingTime;
//   final List<TeamScore>? teams;
//   final List<PlayerScore>? players;

//   factory ScoreboardModel.fromJson(Map<String, dynamic> json) {
//     return ScoreboardModel(
//       sessionId: json["sessionId"],
//       caseName: json["caseName"],
//       remainingTime: json["remainingTime"],
//       teams:
//           json["teams"] != null
//               ? (json["teams"] as List)
//                   .map((e) => TeamScore.fromJson(e))
//                   .toList()
//               : null,
//       players:
//           json["players"] != null
//               ? (json["players"] as List)
//                   .map((e) => PlayerScore.fromJson(e))
//                   .toList()
//               : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "sessionId": sessionId,
//     "caseName": caseName,
//     "remainingTime": remainingTime,
//     "teams": teams?.map((e) => e.toJson()).toList(),
//     "players": players?.map((e) => e.toJson()).toList(),
//   };
// }

// class TeamScore {
//   TeamScore({
//     this.teamId,
//     this.teamName,
//     this.teamNumber,
//     this.teamScore,
//     this.players,
//   });

//   final String? teamId;
//   final String? teamName;
//   final int? teamNumber;
//   final int? teamScore;
//   final List<PlayerScore>? players;

//   factory TeamScore.fromJson(Map<String, dynamic> json) {
//     return TeamScore(
//       teamId: json["teamId"],
//       teamName: json["teamName"],
//       teamNumber: json["teamNumber"],
//       teamScore: json["teamScore"] ?? 0,
//       players:
//           json["players"] != null
//               ? (json["players"] as List)
//                   .map((e) => PlayerScore.fromJson(e))
//                   .toList()
//               : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "teamId": teamId,
//     "teamName": teamName,
//     "teamNumber": teamNumber,
//     "teamScore": teamScore,
//     "players": players?.map((e) => e.toJson()).toList(),
//   };
// }

// class PlayerScore {
//   PlayerScore({this.userId, this.userName, this.individualScore});

//   final String? userId;
//   final String? userName;
//   final int? individualScore;

//   factory PlayerScore.fromJson(Map<String, dynamic> json) {
//     return PlayerScore(
//       userId: json["userId"],
//       userName: json["userName"],
//       individualScore: json["individualScore"] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "userName": userName,
//     "individualScore": individualScore,
//   };
// }
class ScoreboardModel {
  ScoreboardModel({
    required this.sessionId,
    required this.caseName,
    required this.sessionMode,
    required this.remainingTime,
    required this.totalQuestions,
    required this.currentQuestion,
    required this.teams,
    this.players, // Add players field for solo mode
  });

  final String? sessionId;
  final String? caseName;
  final String? sessionMode;
  final String? remainingTime;
  final int? totalQuestions;
  final CurrentQuestion? currentQuestion;
  final List<Team> teams;
  final List<Player>? players; // Add players field for solo mode

  factory ScoreboardModel.fromJson(Map<String, dynamic> json) {
    return ScoreboardModel(
      sessionId: json["sessionId"],
      caseName: json["caseName"],
      sessionMode: json["sessionMode"],
      remainingTime: json["remainingTime"],
      totalQuestions: json["totalQuestions"],
      currentQuestion:
          json["currentQuestion"] == null
              ? null
              : CurrentQuestion.fromJson(json["currentQuestion"]),
      teams:
          json["teams"] == null
              ? []
              : List<Team>.from(json["teams"]!.map((x) => Team.fromJson(x))),
      players:
          json["players"] == null
              ? null
              : List<Player>.from(
                json["players"]!.map((x) => Player.fromJson(x)),
              ), // Parse players array
    );
  }
}

class CurrentQuestion {
  CurrentQuestion({
    required this.questionId,
    required this.questionNumber,
    required this.questionEn,
    required this.questionAr,
  });

  final String? questionId;
  final int? questionNumber;
  final String? questionEn;
  final String? questionAr;

  factory CurrentQuestion.fromJson(Map<String, dynamic> json) {
    return CurrentQuestion(
      questionId: json["questionId"],
      questionNumber: json["questionNumber"],
      questionEn: json["questionEn"],
      questionAr: json["questionAr"],
    );
  }
}

class Team {
  Team({
    required this.teamId,
    required this.teamName,
    required this.teamNumber,
    required this.leaderName,
    required this.leaderPhotoUrl,
    required this.members,
    required this.players,
    required this.teamScore,
    required this.questionProgress,
    required this.questionsAnswered,
    required this.totalQuestions,
  });

  final String? teamId;
  final String? teamName;
  final int? teamNumber;
  final String? leaderName;
  final String? leaderPhotoUrl;
  final List<Member> members;
  final List<Player> players;
  final int? teamScore;
  final List<QuestionProgress> questionProgress;
  final int? questionsAnswered;
  final int? totalQuestions;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json["teamId"],
      teamName: json["teamName"],
      teamNumber: json["teamNumber"],
      leaderName: json["leaderName"],
      leaderPhotoUrl: json["leaderPhotoURL"],
      members:
          json["members"] == null
              ? []
              : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x)),
              ),
      players:
          json["players"] == null
              ? []
              : List<Player>.from(
                json["players"]!.map((x) => Player.fromJson(x)),
              ),
      teamScore: json["teamScore"],
      questionProgress:
          json["questionProgress"] == null
              ? []
              : List<QuestionProgress>.from(
                json["questionProgress"]!.map(
                  (x) => QuestionProgress.fromJson(x),
                ),
              ),
      questionsAnswered: json["questionsAnswered"],
      totalQuestions: json["totalQuestions"],
    );
  }
}

class Member {
  Member({
    required this.id,
    required this.userId,
    required this.name,
    required this.photoUrl,
    required this.isLeader,
    required this.individualScore,
    required this.hasAnswered,
    required this.questionsAnswered,
    required this.correctAnswers,
  });

  final String? id;
  final String? userId;
  final String? name;
  final String? photoUrl;
  final bool? isLeader;
  final int? individualScore;
  final bool? hasAnswered;
  final int? questionsAnswered;
  final int? correctAnswers;

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      photoUrl: json["photoURL"],
      isLeader: json["isLeader"],
      individualScore: json["individualScore"],
      hasAnswered: json["hasAnswered"],
      questionsAnswered: json["questionsAnswered"],
      correctAnswers: json["correctAnswers"],
    );
  }
}

class Player {
  Player({
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.individualScore,
    required this.hasAnswered,
    required this.isLeader,
    required this.questionsAnswered,
    required this.correctAnswers,
  });

  final String? userId;
  final String? userName;
  final String? userPhotoUrl;
  final int? individualScore;
  final bool? hasAnswered;
  final bool? isLeader;
  final int? questionsAnswered;
  final int? correctAnswers;

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json["userId"],
      userName: json["userName"],
      userPhotoUrl: json["userPhotoURL"],
      individualScore: json["individualScore"],
      hasAnswered: json["hasAnswered"],
      isLeader: json["isLeader"],
      questionsAnswered: json["questionsAnswered"],
      correctAnswers: json["correctAnswers"],
    );
  }
}

class QuestionProgress {
  QuestionProgress({
    required this.questionNumber,
    required this.questionId,
    required this.status,
    required this.answerStatus,
    required this.score,
    required this.nodeColor,
  });

  final int? questionNumber;
  final String? questionId;
  final String? status;
  final String? answerStatus;
  final int? score;
  final String? nodeColor;

  factory QuestionProgress.fromJson(Map<String, dynamic> json) {
    return QuestionProgress(
      questionNumber: json["questionNumber"],
      questionId: json["questionId"],
      status: json["status"],
      answerStatus: json["answerStatus"],
      score: json["score"],
      nodeColor: json["nodeColor"],
    );
  }
}
