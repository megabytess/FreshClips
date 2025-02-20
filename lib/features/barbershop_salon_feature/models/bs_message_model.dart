import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // final String senderId;
  final String senderName;
  final String senderEmail;
  final String senderImageUrl;
  // final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String receiverImageUrl;
  final String content;
  final Timestamp createdAt;
  final bool isRead;

  Message({
    // required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.senderImageUrl,
    // required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverImageUrl,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });

  // Convert Message object to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      // 'senderId': senderId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderImageUrl': senderImageUrl,
      // 'receiverId': receiverId,
      'receiverEmail': receiverEmail,
      'receiverName': receiverName,
      'receiverImageUrl': receiverImageUrl,
      'content': content,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  // Create a Message object from Firestore data
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      // senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      senderImageUrl: map['senderImageUrl'] ?? '',
      // receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverEmail: map['receiverEmail'] ?? '',
      receiverImageUrl: map['receiverImageUrl'] ?? '',
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}
