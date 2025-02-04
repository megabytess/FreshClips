import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_message_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BSChatroomMessagePage extends StatefulWidget {
  const BSChatroomMessagePage({
    super.key,
    required this.clientEmail,
    required this.userEmail,
    required this.chatRoomId,
    required this.receiverEmail,
  });
  final String clientEmail;
  final String userEmail;
  final String chatRoomId;
  final String receiverEmail;

  @override
  State<BSChatroomMessagePage> createState() => _BSChatroomMessagePageState();
}

class _BSChatroomMessagePageState extends State<BSChatroomMessagePage> {
  final MessageController messageController = MessageController();
  String accountName = "Loading...";
  String accountImage = '';
  late String chatRoomId;

  TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatRoomId = widget.chatRoomId;
    fetchChatMessages(chatRoomId);
    debugPrint('Chat Room ID: $chatRoomId');
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> fetchChatMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .where('email',
                  isEqualTo: widget.userEmail ==
                          FirebaseAuth.instance.currentUser!.email
                      ? widget.clientEmail
                      : widget.userEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              );
            }

            var userData = snapshot.data!.docs.first.data();
            String accountImage = userData['imageUrl'] ?? '';
            String accountName = userData['username'] ?? 'Unknown';

            return Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.04,
                  backgroundImage: accountImage.isNotEmpty
                      ? NetworkImage(accountImage)
                      : const AssetImage('assets/images/icons/logo_icon.png')
                          as ImageProvider<Object>,
                  backgroundColor: Colors.transparent,
                ),
                Gap(screenWidth * 0.02),
                Text(
                  '@$accountName',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) {
        //             return BSChatroomInfoPage(
        //               chatRoomId: widget.chatRoomId,
        //             );
        //           },
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.info_outline_rounded),
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: fetchChatMessages(chatRoomId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 189, 49, 71),
                        ),
                      ));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Messages will appear here',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var messageData = snapshot.data!.docs[index];

                        String senderEmail = messageData['senderEmail'];
                        String content = messageData['content'];
                        Timestamp createdAt = messageData['createdAt'];
                        String messageTime =
                            DateFormat('h:mm a').format(createdAt.toDate());
                        String senderImageUrl =
                            messageData['senderImageUrl'] ?? '';

                        bool isSender = senderEmail ==
                            FirebaseAuth.instance.currentUser!.email;

                        return Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.002,
                              horizontal: screenWidth * 0.042,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: isSender
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // If receiver, show avatar before the message
                                if (!isSender)
                                  CircleAvatar(
                                    radius: screenWidth * 0.03,
                                    backgroundImage:
                                        NetworkImage(senderImageUrl),
                                    backgroundColor: Colors.transparent,
                                  ),
                                if (!isSender) Gap(screenWidth * 0.02),

                                Column(
                                  crossAxisAlignment: isSender
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    // Message bubble
                                    Container(
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.03),
                                      decoration: BoxDecoration(
                                        color: isSender
                                            ? const Color.fromARGB(
                                                255, 189, 49, 71)
                                            : const Color.fromARGB(
                                                255, 48, 65, 69),
                                        borderRadius: BorderRadius.only(
                                          topLeft: isSender
                                              ? Radius.circular(
                                                  screenWidth * 0.05)
                                              : Radius.circular(
                                                  screenWidth * 0.05),
                                          topRight: Radius.circular(
                                              screenWidth * 0.05),
                                          bottomLeft: isSender
                                              ? Radius.circular(
                                                  screenWidth * 0.05)
                                              : Radius.circular(
                                                  screenWidth * 0.05),
                                          bottomRight: isSender
                                              ? Radius.circular(
                                                  screenWidth * 0.01)
                                              : Radius.circular(
                                                  screenWidth * 0.05),
                                        ),
                                      ),
                                      child: Text(
                                        content,
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.028,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 248, 248, 248),
                                        ),
                                      ),
                                    ),

                                    Gap(screenHeight * 0.002),
                                    Text(
                                      '   $messageTime',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.02,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // Chat Input Field
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Container(
                height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(screenWidth * 0.08),
                  border: Border.all(
                    color: const Color.fromARGB(255, 69, 69, 69),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Start a conversation',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.03,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                            screenWidth * 0.05,
                            screenHeight * 0.015,
                            screenWidth * 0.05,
                            0,
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          fontSize: screenWidth * 0.035,
                        ),
                        maxLines: 11,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.02),
                      child: SizedBox(
                        height: screenHeight * 0.045,
                        width: screenWidth * 0.15,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (message.text.trim().isEmpty) {
                              debugPrint('Cannot send an empty message');
                              return;
                            }

                            await messageController.betaSendMessage(
                              receiverEmail: widget.userEmail,
                              content: message.text.trim(),
                            );

                            message.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 189, 49, 71),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03),
                          ),
                          child: Text(
                            'SEND',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 248, 248, 248),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
