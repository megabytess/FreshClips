import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_message_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/message_page/screens/bs_receiver_chatroom_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HairstylistMessagePage extends StatefulWidget {
  const HairstylistMessagePage(
      {super.key, required this.userEmail, required this.clientEmail});

  final String userEmail;
  final String clientEmail;

  @override
  State<HairstylistMessagePage> createState() => _HairstylistMessagePageState();
}

class _HairstylistMessagePageState extends State<HairstylistMessagePage> {
  MessageController messageController = MessageController();
  List<DocumentSnapshot> chatrooms = [];
  Map<String, String> latestMessages = {};
  Map<String, Timestamp> latestMessageTimes = {};
  String accountImage = '';
  Map<String, String> senderNames = {};
  Map<String, String> senderImages = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatRooms')
              .where('receiverEmail', isEqualTo: widget.clientEmail)
              .snapshots(),
          builder: (context, chatroomSnapshot) {
            if (chatroomSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 189, 49, 71),
                ),
              );
            }

            if (!chatroomSnapshot.hasData ||
                chatroomSnapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'Messages will appear here',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[500],
                  ),
                ),
              );
            }

            final chatrooms = chatroomSnapshot.data!.docs;

            return ListView.builder(
              itemCount: chatrooms.length,
              itemBuilder: (context, index) {
                final chatroom = chatrooms[index];
                final chatroomId = chatroom.id;
                final senderEmail = chatroom['senderEmail'] ?? '';
                final senderImageUrl = chatroom['senderImageUrl'] ?? '';
                final senderName = chatroom['senderUsername'] ?? '';
                final latestMessage =
                    chatroom['latestMessage'] ?? 'No messages';
                String latestMessageTime = 'Unknown time';
                final Timestamp? latestMessageAt =
                    chatroom['latestMessageTime'];

                if (latestMessageAt != null) {
                  latestMessageTime =
                      DateFormat('h:mm a').format(latestMessageAt.toDate());
                }

                return InkWell(
                  onTap: () {
                    debugPrint('Navigating to BSReceiverChatroomPage with:');
                    debugPrint('userEmail: ${widget.userEmail}');
                    debugPrint('clientEmail: ${widget.clientEmail}');
                    debugPrint('chatRoomId: $chatroomId');
                    debugPrint('senderEmail: $senderEmail');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BSReceiverChatroomPage(
                          userEmail: widget.userEmail,
                          clientEmail: widget.clientEmail,
                          chatRoomId: chatroomId,
                          senderEmail: senderEmail,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: screenWidth * 0.07,
                            backgroundImage: senderImageUrl.isNotEmpty
                                ? NetworkImage(senderImageUrl)
                                : const AssetImage(
                                        'assets/images/icons/logo_icon.png')
                                    as ImageProvider<Object>,
                            backgroundColor: Colors.transparent,
                          ),
                          Gap(screenWidth * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '@$senderName',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      latestMessageTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  latestMessage,
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.032,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(screenHeight * 0.02),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
