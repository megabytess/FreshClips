import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class MessageController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Generate chat room ID (Ensures consistent ordering)
  String generateChatRoomId(String currentEmail, String receiverEmail) {
    List<String> emails = [currentEmail, receiverEmail];
    emails.sort();
    return emails.join('_');
  }

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      QuerySnapshot userQuerySnapshot = await firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      QueryDocumentSnapshot<Object?>? userSnapshot =
          userQuerySnapshot.docs.isNotEmpty
              ? userQuerySnapshot.docs.first
              : null;

      if (userSnapshot != null && userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> betaSendMessage({
    required String receiverEmail,
    required String content,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String senderEmail = auth.currentUser!.email!;
    final String chatRoomId = generateChatRoomId(senderEmail, receiverEmail);

    final DocumentReference chatRoomRef =
        firestore.collection('chatRooms').doc(chatRoomId);
    final CollectionReference messagesRef = chatRoomRef.collection('messages');

    final Timestamp now = Timestamp.now();

    // Fetch the sender and receiver details
    Map<String, dynamic>? senderData = await getUserData(senderEmail);
    Map<String, dynamic>? receiverData = await getUserData(receiverEmail);

    if (senderData == null) {
      debugPrint('Error: Sender data not found for email: $senderEmail');
      return;
    }

    if (receiverData == null) {
      debugPrint('Error: Receiver data not found for email: $receiverEmail');
      return;
    }

    // Check if the chat room exists
    final chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      // If the chat room does not exist, create it with sender and receiver details
      await chatRoomRef.set({
        'chatRoomId': chatRoomId,
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
        'createdAt': now,
        'latestMessage': content,
        'latestMessageTime': now,
        'senderUsername': senderData['username'] ?? '',
        'senderImageUrl': senderData['imageUrl'] ?? '',
        'receiverUsername': receiverData['username'] ?? '',
        'receiverImageUrl': receiverData['imageUrl'] ?? '',
      });
    } else {
      // Update only the latest message and timestamp, keeping sender and receiver unchanged
      await chatRoomRef.update({
        'latestMessage': content,
        'latestMessageTime': now,
      });
    }

    // Add the new message with sender and receiver details
    await messagesRef.add({
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'content': content,
      'senderUsername': senderData['username'] ?? '',
      'senderImageUrl': senderData['imageUrl'] ?? '',
      'receiverUsername': receiverData['username'] ?? '',
      'receiverImageUrl': receiverData['imageUrl'] ?? '',
      'createdAt': now,
    });
  }
}


// Send message function
  // Future<void> sendMessage({
  //   required String receiverEmail,
  //   required String content,
  // }) async {
  //   try {
  //     final String senderEmail = auth.currentUser!.email!;
  //     Map<String, dynamic>? senderData = await getUserData(senderEmail);
  //     Map<String, dynamic>? receiverData = await getUserData(receiverEmail);

  //     if (senderData == null) {
  //       debugPrint('Error: Sender data not found for email: $senderEmail');
  //       return;
  //     }

  //     if (receiverData == null) {
  //       debugPrint('Error: Receiver data not found for email: $receiverEmail');
  //       return;
  //     }

  //     String trimmedContent = content.trim();
  //     if (trimmedContent.isEmpty) {
  //       debugPrint('Message not sent: Empty content.');
  //       return;
  //     }

  //     // Create message object
  //     Message message = Message(
  //       senderName: senderData['username'] ?? 'Unknown Sender',
  //       senderEmail: senderEmail,
  //       senderImageUrl: senderData['imageUrl'] ?? '',
  //       receiverName: receiverData['username'] ?? 'Unknown Receiver',
  //       receiverEmail: receiverEmail,
  //       receiverImageUrl: receiverData['imageUrl'] ?? '',
  //       content: trimmedContent,
  //       createdAt: Timestamp.now(),
  //       isRead: false,
  //     );

  //     List<String> emails = [senderEmail, receiverEmail];
  //     emails.sort();
  //     final String chatRoomId = emails.join('_');

  //     // Check if chat room exists
  //     DocumentReference chatRoomRef =
  //         firestore.collection('chatRooms').doc(chatRoomId);
  //     DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

  //     if (!chatRoomSnapshot.exists) {
  //       // Create chat room with creation timestamp and members
  //       await chatRoomRef.set({
  //         'createdAt': Timestamp.now(),
  //         'members': emails,
  //       });
  //       debugPrint('Chat room created: $chatRoomId');
  //     }
  //     await firestore
  //         .collection('chatRooms')
  //         .doc(chatRoomId)
  //         .collection('messages')
  //         .add(message.toMap());

  //     debugPrint('Message sent successfully: ${message.content}');
  //   } catch (e) {
  //     debugPrint('Error sending message: $e');
  //   }
  // }
