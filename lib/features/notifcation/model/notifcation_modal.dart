class NotificationResponse {
  final List<NotificationMessage>? data;
  final int total;
  final int page;
  final int limit;

  NotificationResponse({
    this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      data: json['data'] != null
          ? List<NotificationMessage>.from(
              json['data'].map((x) => NotificationMessage.fromJson(x)))
          : null,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }

  NotificationResponse copyWith({
    List<NotificationMessage>? data,
    int? total,
    int? page,
    int? limit,
  }) {
    return NotificationResponse(
      data: data ?? this.data,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

class NotificationMessage {
  final String? id;
  final String? messageTitle;
  final String? messageBody;
  final String? inAppMessageTitle;
  final String? inAppMessageBody;
  final AdditionalData? additionalData;
  final String? state;
  final String? notificationType;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;

  NotificationMessage({
    this.id,
    this.messageTitle,
    this.messageBody,
    this.inAppMessageTitle,
    this.inAppMessageBody,
    this.additionalData,
    this.state,
    this.notificationType,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      id: json['id']?.toString(),
      messageTitle: json['messageTitle']?.toString(),
      messageBody: json['messageBody']?.toString(),
      inAppMessageTitle: json['inAppMessageTitle']?.toString(),
      inAppMessageBody: json['inAppMessageBody']?.toString(),
      additionalData: json['additionalData'] != null
          ? AdditionalData.fromJson(json['additionalData'])
          : null,
      state: json['state']?.toString() ?? 'not_opened',
      notificationType: json['notificationType']?.toString() ?? 'general',
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      userId: json['userId']?.toString(),
    );
  }

  NotificationMessage copyWith({
    String? id,
    String? messageTitle,
    String? messageBody,
    String? inAppMessageTitle,
    String? inAppMessageBody,
    AdditionalData? additionalData,
    String? state,
    String? notificationType,
    String? createdAt,
    String? updatedAt,
    String? userId,
  }) {
    return NotificationMessage(
      id: id ?? this.id,
      messageTitle: messageTitle ?? this.messageTitle,
      messageBody: messageBody ?? this.messageBody,
      inAppMessageTitle: inAppMessageTitle ?? this.inAppMessageTitle,
      inAppMessageBody: inAppMessageBody ?? this.inAppMessageBody,
      additionalData: additionalData ?? this.additionalData,
      state: state ?? this.state,
      notificationType: notificationType ?? this.notificationType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  String get category {
    switch (additionalData?.action) {
      case 'BOOKING_CONFIRMED':
      case 'BOOKING_UPDATED':
      case 'BOOKING_CANCELLED':
        return 'Bookings';
      case 'PAYMENT_SUCCESS':
      case 'PAYMENT_FAILED':
      case 'PAYMENT_REFUND':
        return 'Payments';
      case 'PROFILE_UPDATE':
      case 'LOYALTY_POINTS':
        return 'Profile';
      default:
        return  'Other';
    }
  }
}

class AdditionalData {
  final String? bookingId;
  final String? userContext;
  final String? action;

  AdditionalData({
    this.bookingId,
    this.userContext,
    this.action,
  });

  factory AdditionalData.fromJson(Map<String, dynamic> json) {
    return AdditionalData(
      bookingId: json['bookingId']?.toString(),
      userContext: json['userContext']?.toString(),
      action: json['action']?.toString(),
    );
  }

  AdditionalData copyWith({
    String? bookingId,
    String? userContext,
    String? action,
  }) {
    return AdditionalData(
      bookingId: bookingId ?? this.bookingId,
      userContext: userContext ?? this.userContext,
      action: action ?? this.action,
    );
  }
}