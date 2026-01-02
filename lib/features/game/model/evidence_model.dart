class EvidenceModel {
  EvidenceModel({
    this.id,
    this.gameId,
    this.questionId,
    this.evidenceName,
    this.evidenceNameAr,
    this.description,
    this.descriptionAr,
    this.profileImageURL,
    this.profileImage,
    this.attachments,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? gameId;
  final String? questionId;
  final String? evidenceName;
  final String? evidenceNameAr;
  final String? description;
  final String? descriptionAr;
  final String? profileImageURL;
  final String? profileImage;
  final List<EvidenceAttachment>? attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      id: json["id"],
      gameId: json["gameId"],
      questionId: json["questionId"],
      evidenceName: json["evidenceName"],
      evidenceNameAr: json["evidenceNameAr"],
      description: json["description"],
      descriptionAr: json["descriptionAr"],
      profileImageURL: json["profileImageURL"],
      profileImage: json["profileImage"],
      attachments: json["attachments"] != null
          ? (json["attachments"] as List)
              .map((e) => EvidenceAttachment.fromJson(e))
              .toList()
          : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "gameId": gameId,
    "questionId": questionId,
    "evidenceName": evidenceName,
    "evidenceNameAr": evidenceNameAr,
    "description": description,
    "descriptionAr": descriptionAr,
    "profileImageURL": profileImageURL,
    "profileImage": profileImage,
    "attachments": attachments?.map((e) => e.toJson()).toList(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class EvidenceAttachment {
  EvidenceAttachment({
    this.id,
    this.attachmentNameEn,
    this.attachmentNameAr,
    this.attachmentType,
    this.mediaUrl,
    this.uploadId,
    this.thumbnailUrl,
  });

  final String? id;
  final String? attachmentNameEn;
  final String? attachmentNameAr;
  final String? attachmentType; // video, image, document, audio
  final String? mediaUrl;
  final String? uploadId;
  final String? thumbnailUrl;

  factory EvidenceAttachment.fromJson(Map<String, dynamic> json) {
    return EvidenceAttachment(
      id: json["id"],
      attachmentNameEn: json["attachmentNameEn"],
      attachmentNameAr: json["attachmentNameAr"],
      attachmentType: json["attachmentType"],
      mediaUrl: json["mediaUrl"],
      uploadId: json["uploadId"],
      thumbnailUrl: json["thumbnailUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "attachmentNameEn": attachmentNameEn,
    "attachmentNameAr": attachmentNameAr,
    "attachmentType": attachmentType,
    "mediaUrl": mediaUrl,
    "uploadId": uploadId,
    "thumbnailUrl": thumbnailUrl,
  };
}



