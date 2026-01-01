class CutsceneModel {
  CutsceneModel({
    this.id,
    this.title,
    this.titleAr,
    this.content,
    this.contentAr,
    this.type,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.isSkippable,
    this.autoPlay,
    this.order,
    this.gameId,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? title;
  final String? titleAr;
  final String? content;
  final String? contentAr;
  final String? type; // intro, clue_reveal, transition
  final String? mediaType; // video, image, audio
  final String? mediaUrl;
  final String? thumbnailUrl;
  final bool? isSkippable;
  final bool? autoPlay;
  final int? order;
  final String? gameId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CutsceneModel.fromJson(Map<String, dynamic> json) {
    return CutsceneModel(
      id: json["id"],
      title: json["title"] ?? json["titleEn"],
      titleAr: json["titleAr"],
      content: json["content"] ?? json["contentEn"],
      contentAr: json["contentAr"],
      type: json["type"],
      mediaType: json["mediaType"],
      mediaUrl: json["mediaUrl"],
      thumbnailUrl: json["thumbnailUrl"],
      isSkippable: json["isSkippable"] ?? false,
      autoPlay: json["autoPlay"] ?? false,
      order: json["order"],
      gameId: json["gameId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "titleAr": titleAr,
    "content": content,
    "contentAr": contentAr,
    "type": type,
    "mediaType": mediaType,
    "mediaUrl": mediaUrl,
    "thumbnailUrl": thumbnailUrl,
    "isSkippable": isSkippable,
    "autoPlay": autoPlay,
    "order": order,
    "gameId": gameId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}


