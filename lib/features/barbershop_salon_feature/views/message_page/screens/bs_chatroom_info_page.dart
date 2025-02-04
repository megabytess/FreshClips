import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_message_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';

class BSChatroomInfoPage extends StatefulWidget {
  const BSChatroomInfoPage({
    super.key,
    required this.chatRoomId,
  });

  final String chatRoomId;

  @override
  State<BSChatroomInfoPage> createState() => _BSChatroomInfoPageState();
}

class _BSChatroomInfoPageState extends State<BSChatroomInfoPage> {
  final MessageController messageController = MessageController();
  late final RatingsReviewController ratingsReviewController;
  late final Stream<QuerySnapshot> chatRoomStream;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
