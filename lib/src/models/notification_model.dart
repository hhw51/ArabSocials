class UserNotification {
  final int id;
  final String? title;
  final String? message;
  final String? timestamp;
  final String? eventTitle;
  final String? senderImage;

  UserNotification({
    required this.id,
    this.title,
    this.message,
    this.timestamp,
    this.eventTitle,
    this.senderImage,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['message'] ?? 'No Title',
      message: json['event']?['title'] ?? null,
      timestamp: json['created_at'] ?? 'No Timestamp',
      eventTitle: json['event']?['title'],
      senderImage: json['sender']?['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'eventTitle': eventTitle,
      'senderImage': senderImage,
    };
  }
}
