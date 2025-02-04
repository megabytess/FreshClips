import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/views/message_page/screens/client_chatroom_message_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClientMessagePage extends StatefulWidget {
  final String userEmail;
  final String clientEmail;

  const ClientMessagePage(
      {super.key, required this.userEmail, required this.clientEmail});

  @override
  ClientMessagePageState createState() => ClientMessagePageState();
}

class ClientMessagePageState extends State<ClientMessagePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatRooms')
              .where('senderEmail', isEqualTo: widget.userEmail)
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

            // ListView to display chat rooms
            return ListView.builder(
              itemCount: chatrooms.length,
              itemBuilder: (context, index) {
                final chatroom = chatrooms[index];
                final chatroomId = chatroom.id;
                final receiverEmail = chatroom['receiverEmail'] ?? 'Unknown';
                final receiverImageUrl = chatroom['receiverImageUrl'] ?? '';
                final receiverName = chatroom['receiverUsername'] ?? '';
                final latestMessage =
                    chatroom['latestMessage'] ?? 'No messages';
                String latestMessageTime = 'Unknown time';
                final Timestamp? latestMessageAt =
                    chatroom['latestMessageTime'];

                if (latestMessageAt != null) {
                  latestMessageTime =
                      DateFormat('h:mm a').format(latestMessageAt.toDate());
                }

                debugPrint('ChatRoom ID: $chatroomId');

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientChatroomMessagePage(
                          userEmail: widget.userEmail,
                          chatRoomId: chatroomId,
                          clientEmail: widget.clientEmail,
                          receiverEmail: receiverEmail, // nigana tawn
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Display sender's avatar
                          CircleAvatar(
                            radius: screenWidth * 0.07,
                            backgroundImage: receiverImageUrl.isNotEmpty
                                ? NetworkImage(receiverImageUrl)
                                : const AssetImage(
                                        'assets/images/icons/logo_icon.png')
                                    as ImageProvider<Object>,
                            backgroundColor: Colors.transparent,
                          ),
                          Gap(screenWidth * 0.05),
                          // Display message details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      receiverName,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
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
                                Gap(screenHeight * 0.005),
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
