class UserAnswerModel {
  UserAnswerModel({
    this.id,
    this.sessionId,
    this.questionId,
    this.userId,
    this.selectedOptionIds,
    this.isCorrect,
    this.pointsEarned,
    this.timeSpentSeconds,
    this.hintUsed,
    this.createdAt,
    this.updatedAt,
    this.unlockMessageEn,
    this.unlockMessageAr,
    this.unlockedEvidenceCount,
    this.unlockedEvidenceIds,
  });

  final String? id;
  final String? sessionId;
  final String? questionId;
  final String? userId;
  final List<String>? selectedOptionIds;
  final bool? isCorrect;
  final int? pointsEarned;
  final int? timeSpentSeconds;
  final bool? hintUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? unlockMessageEn;
  final String? unlockMessageAr;
  final int? unlockedEvidenceCount;
  final List<String>? unlockedEvidenceIds;

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      id: json["id"],
      sessionId: json["sessionId"],
      questionId: json["questionId"],
      userId: json["userId"],
      selectedOptionIds: json["selectedOptionIds"] != null ? List<String>.from(json["selectedOptionIds"]) : null,
      isCorrect: json["isCorrect"] ?? false,
      pointsEarned: json["pointsEarned"] ?? 0,
      timeSpentSeconds: json["timeSpentSeconds"] ?? 0,
      hintUsed: json["hintUsed"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      unlockMessageEn: json["unlockMessageEn"],
      unlockMessageAr: json["unlockMessageAr"],
      unlockedEvidenceCount: json["unlockedEvidenceCount"],
      unlockedEvidenceIds: json["unlockedEvidenceIds"] != null ? List<String>.from(json["unlockedEvidenceIds"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "questionId": questionId,
    "userId": userId,
    "selectedOptionIds": selectedOptionIds,
    "isCorrect": isCorrect,
    "pointsEarned": pointsEarned,
    "timeSpentSeconds": timeSpentSeconds,
    "hintUsed": hintUsed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "unlockMessageEn": unlockMessageEn,
    "unlockMessageAr": unlockMessageAr,
    "unlockedEvidenceCount": unlockedEvidenceCount,
    "unlockedEvidenceIds": unlockedEvidenceIds,
  };
}
