class Notification {
  String? id;
  int? userId;
  int? notificationType;
  String? title;
  String? notification;
  int? matchId;
  DateTime? date;
  int status;
  int? isSend;

  Notification({
    this.id,
    this.userId,
    this.notificationType,
    this.title,
    this.notification,
    this.matchId,
    this.date,
    required this.status,
    this.isSend,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id']?.toString(),
      userId: json['user_id'],
      notificationType: json['notification_type'],
      title: json['title'],
      notification: json['notification'],
      matchId: json['match_id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'],
      isSend: json['is_send'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'notification_type': notificationType,
      'title': title,
      'notification': notification,
      'match_id': matchId,
      'date': date?.toIso8601String(),
      'status': status,
      'is_send': isSend,
    };
  }
}