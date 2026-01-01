class QuestionModel {
  QuestionModel({
    required this.id,
    required this.gameId,
    required this.question,
    required this.type,
    required this.correctAnswerId,
    required this.points,
    required this.difficulty,
    required this.order,
    required this.isRequired,
    required this.isFinalAccusation,
    required this.answers,
    required this.hints,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? gameId;
  final String? question;
  final String? type;
  final String? correctAnswerId;
  final int? points;
  final int? difficulty;
  final int? order;
  final bool? isRequired;
  final bool? isFinalAccusation;
  final List<Answer> answers;
  final List<Hint> hints;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json["id"],
      gameId: json["gameId"],
      question: json["question"],
      type: json["type"],
      correctAnswerId: json["correctAnswerId"],
      points: json["points"],
      difficulty: json["difficulty"],
      order: json["order"],
      isRequired: json["isRequired"],
      isFinalAccusation: json["isFinalAccusation"],
      answers:
          json["answers"] == null
              ? []
              : List<Answer>.from(
                json["answers"]!.map((x) => Answer.fromJson(x)),
              ),
      hints:
          json["hints"] == null
              ? []
              : List<Hint>.from(json["hints"]!.map((x) => Hint.fromJson(x))),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}

class Answer {
  Answer({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? questionId;
  final String? answerText;
  final bool? isCorrect;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json["id"],
      questionId: json["questionId"],
      answerText: json["answerText"],
      isCorrect: json["isCorrect"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}

class Hint {
  Hint({
    required this.id,
    required this.questionId,
    required this.hintName,
    required this.hintDescription,
    required this.hintType,
    required this.mediaUrl,
    required this.thumbnailId,
    required this.thumbnailUrl,
    required this.pointsCost,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? questionId;
  final String? hintName;
  final String? hintDescription;
  final String? hintType;
  final String? mediaUrl;
  final dynamic thumbnailId;
  final dynamic thumbnailUrl;
  final int? pointsCost;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Hint.fromJson(Map<String, dynamic> json) {
    return Hint(
      id: json["id"],
      questionId: json["questionId"],
      hintName: json["hintName"],
      hintDescription: json["hintDescription"],
      hintType: json["hintType"],
      mediaUrl: json["mediaUrl"],
      thumbnailId: json["thumbnailId"],
      thumbnailUrl: json["thumbnailUrl"],
      pointsCost: json["pointsCost"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}
