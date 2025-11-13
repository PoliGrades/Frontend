class Message {
  final String roomId;
  final int senderId;
  final String senderName;
  final String senderRole;
  final String message;
  final DateTime timestamp;
  final String id;

  Message({
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.timestamp,
    required this.id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      roomId: json['room_id'].toString(),
      senderId: json['sender_id'],
      senderName: json['sender_name'].toString(),
      senderRole: json['sender_role'].toString(),
      message: json['message'].toString(),
      timestamp: DateTime.parse(json['timestamp']),
      id: json['_id'].toString(),
    );
  }
}