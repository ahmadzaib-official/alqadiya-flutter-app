class NotificationModel {
    NotificationModel({
        required this.id,
        required this.title,
        required this.titleInArabic,
        required this.body,
        required this.bodyInArabic,
        required this.pushTitle,
        required this.pushTitleInArabic,
        required this.notificationTypeId,
        required this.notificationCategory,
        required this.notificationPreferenceType,
        required this.sendTo,
        required this.createdAt,
        required this.updatedAt,
        required this.isRead,
    });

    final String? id;
    final String? title;
    final String? titleInArabic;
    final String? body;
    final String? bodyInArabic;
    final String? pushTitle;
    final String? pushTitleInArabic;
    final String? notificationTypeId;
    final String? notificationCategory;
    final String? notificationPreferenceType;
    final String? sendTo;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final bool? isRead;

    NotificationModel copyWith({
        String? id,
        String? title,
        String? titleInArabic,
        String? body,
        String? bodyInArabic,
        String? pushTitle,
        String? pushTitleInArabic,
        String? notificationTypeId,
        String? notificationCategory,
        String? notificationPreferenceType,
        String? sendTo,
        DateTime? createdAt,
        DateTime? updatedAt,
        bool? isRead,
    }) {
        return NotificationModel(
            id: id ?? this.id,
            title: title ?? this.title,
            titleInArabic: titleInArabic ?? this.titleInArabic,
            body: body ?? this.body,
            bodyInArabic: bodyInArabic ?? this.bodyInArabic,
            pushTitle: pushTitle ?? this.pushTitle,
            pushTitleInArabic: pushTitleInArabic ?? this.pushTitleInArabic,
            notificationTypeId: notificationTypeId ?? this.notificationTypeId,
            notificationCategory: notificationCategory ?? this.notificationCategory,
            notificationPreferenceType: notificationPreferenceType ?? this.notificationPreferenceType,
            sendTo: sendTo ?? this.sendTo,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            isRead: isRead ?? this.isRead,
        );
    }

    factory NotificationModel.fromJson(Map<String, dynamic> json){ 
        return NotificationModel(
            id: json["id"],
            title: json["title"],
            titleInArabic: json["titleInArabic"],
            body: json["body"],
            bodyInArabic: json["bodyInArabic"],
            pushTitle: json["pushTitle"],
            pushTitleInArabic: json["pushTitleInArabic"],
            notificationTypeId: json["notificationTypeId"],
            notificationCategory: json["notificationCategory"],
            notificationPreferenceType: json["notificationPreferenceType"],
            sendTo: json["sendTo"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            isRead: json["isRead"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "titleInArabic": titleInArabic,
        "body": body,
        "bodyInArabic": bodyInArabic,
        "pushTitle": pushTitle,
        "pushTitleInArabic": pushTitleInArabic,
        "notificationTypeId": notificationTypeId,
        "notificationCategory": notificationCategory,
        "notificationPreferenceType": notificationPreferenceType,
        "sendTo": sendTo,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "isRead": isRead,
    };

}
