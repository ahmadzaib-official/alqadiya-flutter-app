class SuspectModel {
  SuspectModel({
    this.id,
    this.gameId,
    this.nameEn,
    this.nameAr,
    this.jobEn,
    this.jobAr,
    this.age,
    this.biographyEn,
    this.biographyAr,
    this.profileImageURL,
    this.profileImage,
    this.attachments,
    this.investigationReports,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? gameId;
  final String? nameEn;
  final String? nameAr;
  final String? jobEn;
  final String? jobAr;
  final int? age;
  final String? biographyEn;
  final String? biographyAr;
  final String? profileImageURL;
  final String? profileImage;
  final List<SuspectAttachment>? attachments;
  final List<SuspectAttachment>? investigationReports;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SuspectModel.fromJson(Map<String, dynamic> json) {
    return SuspectModel(
      id: json["id"],
      gameId: json["gameId"],
      nameEn: json["nameEn"],
      nameAr: json["nameAr"],
      jobEn: json["jobEn"],
      jobAr: json["jobAr"],
      age: json["age"],
      biographyEn: json["biographyEn"],
      biographyAr: json["biographyAr"],
      profileImageURL: json["profileImageURL"],
      profileImage: json["profileImage"],
      attachments: json["attachments"] != null
          ? (json["attachments"] as List)
              .map((e) => SuspectAttachment.fromJson(e))
              .toList()
          : null,
      investigationReports: json["investigationReports"] != null
          ? (json["investigationReports"] as List)
              .map((e) => SuspectAttachment.fromJson(e))
              .toList()
          : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "gameId": gameId,
    "nameEn": nameEn,
    "nameAr": nameAr,
    "jobEn": jobEn,
    "jobAr": jobAr,
    "age": age,
    "biographyEn": biographyEn,
    "biographyAr": biographyAr,
    "profileImageURL": profileImageURL,
    "profileImage": profileImage,
    "attachments": attachments?.map((e) => e.toJson()).toList(),
    "investigationReports": investigationReports?.map((e) => e.toJson()).toList(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class SuspectAttachment {
  SuspectAttachment({
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

  factory SuspectAttachment.fromJson(Map<String, dynamic> json) {
    return SuspectAttachment(
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

