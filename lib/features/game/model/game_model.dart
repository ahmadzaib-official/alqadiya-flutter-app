class GameModel {
  GameModel({
    this.id,
    this.title,
    this.description,
    this.difficulty,
    this.coverImage,
    this.coverImageUrl,
    this.costPoints,
    this.estimatedDuration,
    this.totalPlays,
    this.totalCompletions,
    this.averageCompletionTime,
    this.successRate,
    this.isPurchased,
    this.isPlayed,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? difficulty;
  final String? coverImage;
  final String? coverImageUrl;
  final int? costPoints;
  final int? estimatedDuration;
  final int? totalPlays;
  final int? totalCompletions;
  final int? averageCompletionTime;
  final String? successRate;
  final bool? isPurchased;
  final bool? isPlayed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      difficulty: json["difficulty"],
      coverImage: json["coverImage"],
      coverImageUrl: json["coverImageURL"],
      costPoints: json["costPoints"],
      estimatedDuration: json["estimatedDuration"],
      totalPlays: json["totalPlays"],
      totalCompletions: json["totalCompletions"],
      averageCompletionTime: json["averageCompletionTime"],
      successRate: json["successRate"],
      isPurchased: json["isPurchased"],
      isPlayed: json["isPlayed"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "difficulty": difficulty,
    "coverImage": coverImage,
    "coverImageURL": coverImageUrl,
    "costPoints": costPoints,
    "estimatedDuration": estimatedDuration,
    "totalPlays": totalPlays,
    "totalCompletions": totalCompletions,
    "averageCompletionTime": averageCompletionTime,
    "successRate": successRate,
    "isPurchased": isPurchased,
    "isPlayed": isPlayed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
