class QuestionModel {
  QuestionModel({
    this.id,
    this.gameId,
    this.questionEn,
    this.questionAr,
    this.type,
    this.points,
    this.difficulty,
    this.order,
    this.isRequired,
    this.isFinalAccusation,
    this.answers,
    this.hints,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? gameId;
  final String? questionEn;
  final String? questionAr;
  final String? type; // multiple_choice, etc.
  final int? points;
  final int? difficulty;
  final int? order;
  final bool? isRequired;
  final bool? isFinalAccusation;
  final List<AnswerOption>? answers;
  final List<QuestionHint>? hints;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json["id"],
      gameId: json["gameId"],
      questionEn: json["questionEn"] ?? json["question"],
      questionAr: json["questionAr"],
      type: json["type"],
      points: json["points"],
      difficulty: json["difficulty"],
      order: json["order"],
      isRequired: json["isRequired"] ?? false,
      isFinalAccusation: json["isFinalAccusation"] ?? false,
      answers: json["answers"] != null
          ? (json["answers"] as List)
              .map((e) => AnswerOption.fromJson(e))
              .toList()
          : null,
      hints: json["hints"] != null
          ? (json["hints"] as List)
              .map((e) => QuestionHint.fromJson(e))
              .toList()
          : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "gameId": gameId,
    "questionEn": questionEn,
    "questionAr": questionAr,
    "type": type,
    "points": points,
    "difficulty": difficulty,
    "order": order,
    "isRequired": isRequired,
    "isFinalAccusation": isFinalAccusation,
    "answers": answers?.map((e) => e.toJson()).toList(),
    "hints": hints?.map((e) => e.toJson()).toList(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class AnswerOption {
  AnswerOption({
    this.id,
    this.answerText,
    this.answerTextAr,
    this.isCorrect,
  });

  final String? id;
  final String? answerText;
  final String? answerTextAr;
  final bool? isCorrect;

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json["id"],
      answerText: json["answerText"],
      answerTextAr: json["answerTextAr"],
      isCorrect: json["isCorrect"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "answerText": answerText,
    "answerTextAr": answerTextAr,
    "isCorrect": isCorrect,
  };
}

class QuestionHint {
  QuestionHint({
    this.id,
    this.hintName,
    this.hintNameAr,
    this.hintDescription,
    this.hintDescriptionAr,
    this.hintType,
    this.mediaUrl,
    this.uploadId,
    this.pointsCost,
  });

  final String? id;
  final String? hintName;
  final String? hintNameAr;
  final String? hintDescription;
  final String? hintDescriptionAr;
  final String? hintType; // video, image, document, audio
  final String? mediaUrl;
  final String? uploadId;
  final int? pointsCost;

  factory QuestionHint.fromJson(Map<String, dynamic> json) {
    return QuestionHint(
      id: json["id"],
      hintName: json["hintName"],
      hintNameAr: json["hintNameAr"],
      hintDescription: json["hintDescription"],
      hintDescriptionAr: json["hintDescriptionAr"],
      hintType: json["hintType"],
      mediaUrl: json["mediaUrl"],
      uploadId: json["uploadId"],
      pointsCost: json["pointsCost"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "hintName": hintName,
    "hintNameAr": hintNameAr,
    "hintDescription": hintDescription,
    "hintDescriptionAr": hintDescriptionAr,
    "hintType": hintType,
    "mediaUrl": mediaUrl,
    "uploadId": uploadId,
    "pointsCost": pointsCost,
  };
}

