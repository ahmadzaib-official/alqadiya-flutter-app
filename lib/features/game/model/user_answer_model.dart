class UserAnswerModel {
  UserAnswerModel({
    this.id,
    this.sessionId,
    this.questionId,
    this.userId,
    this.selectedOptionId,
    this.isCorrect,
    this.pointsEarned,
    this.timeSpentSeconds,
    this.hintUsed,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? sessionId;
  final String? questionId;
  final String? userId;
  final String? selectedOptionId;
  final bool? isCorrect;
  final int? pointsEarned;
  final int? timeSpentSeconds;
  final bool? hintUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      id: json["id"],
      sessionId: json["sessionId"],
      questionId: json["questionId"],
      userId: json["userId"],
      selectedOptionId: json["selectedOptionId"],
      isCorrect: json["isCorrect"] ?? false,
      pointsEarned: json["pointsEarned"] ?? 0,
      timeSpentSeconds: json["timeSpentSeconds"] ?? 0,
      hintUsed: json["hintUsed"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "questionId": questionId,
    "userId": userId,
    "selectedOptionId": selectedOptionId,
    "isCorrect": isCorrect,
    "pointsEarned": pointsEarned,
    "timeSpentSeconds": timeSpentSeconds,
    "hintUsed": hintUsed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}


