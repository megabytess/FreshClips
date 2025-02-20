import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_post_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class BSCommentPage extends StatefulWidget {
  const BSCommentPage({super.key, required this.email, required this.postId});
  final String email;
  final String postId;

  @override
  State<BSCommentPage> createState() => _BSCommentPageState();
}

class _BSCommentPageState extends State<BSCommentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BSPostController postController = BSPostController();
  Map<String, dynamic>? postDetails;
  TextEditingController commentController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchPostDetails();
  }

// Display the post to be commented on
  Future<void> fetchPostDetails() async {
    try {
      final postDoc =
          await _firestore.collection('posts').doc(widget.postId).get();
      if (postDoc.exists) {
        setState(() {
          postDetails = postDoc.data();
        });
      } else {
        print("Post not found.");
      }
    } catch (e) {
      print("Error fetching post details: $e");
    }
  }

  // fetch comments on that post
  Stream<QuerySnapshot> fetchComments(String postId) {
    final commentsRef =
        _firestore.collection('posts').doc(postId).collection('comments');
    return commentsRef
        .orderBy('commentPublished', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: SvgPicture.asset(
        //   'assets/images/landing_page/freshclips_logo.svg',
        //   height: screenHeight * 0.05,
        //   width: screenWidth * 0.05,
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: SvgPicture.asset(
              'assets/images/profile_page/menu_btn.svg',
              width: 24.0,
              height: 24.0,
            ),
            onSelected: (String result) {
              if (result == 'Report') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String reportReason = '';

                    return AlertDialog(
                      title: Text(
                        'Report Account',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 48, 65, 69),
                        ),
                      ),
                      content: TextFormField(
                        onChanged: (value) {
                          reportReason = value;
                        },
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 48, 65, 69),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Reason for reporting',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                          hintText: 'Enter your reason here',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        maxLines: 2,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (reportReason.trim().isEmpty) {
                              print("Reason cannot be empty.");
                              return;
                            }

                            try {
                              await postController.reportAccount(
                                reporterEmail: widget.email,
                                reportedAccountEmail:
                                    postDetails!['authorName'],
                                postId: widget.postId,
                                reason: reportReason,
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              print("Error reporting account: $e");
                            }
                          },
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Report',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/profile_page/report.svg',
                      width: 20.0,
                      height: 20.0,
                    ),
                    Gap(screenWidth * 0.02),
                    Text(
                      'Report',
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            color: const Color.fromARGB(255, 248, 248, 248),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (postDetails == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Color.fromARGB(255, 189, 49, 71),
                    ),
                  ),
                ),
              ),
            if (postDetails != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 47.0,
                            height: 47.0,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 186, 199, 206),
                            ),
                            child: (postDetails!['imageUrl'] != null &&
                                    postDetails!['imageUrl'].isNotEmpty)
                                ? Image.network(
                                    postDetails!['imageUrl'],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.person, size: 25),
                          ),
                        ),
                        Gap(screenWidth * 0.02),
                        Text(
                          postDetails!['authorName'],
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 48, 65, 69),
                          ),
                        ),
                      ],
                    ),
                    Gap(screenHeight * 0.01),
                    Text(
                      postDetails!['content'] ?? 'No Content',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                    Gap(screenHeight * 0.01),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: postDetails!['postImageUrl'] != null &&
                              postDetails!['postImageUrl']!.isNotEmpty
                          ? Image.network(
                              postDetails!['postImageUrl'],
                              width: screenWidth * 1,
                              height: screenHeight * 0.4,
                              fit: BoxFit.fitWidth,
                            )
                          : const SizedBox.shrink(),
                    ),
                    Gap(screenHeight * 0.01),
                    postDetails!['tags']?.isNotEmpty == true
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 217, 217, 217),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              postDetails!['tags'],
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.023,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 86, 99, 111),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(screenHeight * 0.02),
                    Row(
                      children: [
                        LikeButton(
                          size: 20,
                          isLiked:
                              postDetails!['likedBy'].contains(widget.email),
                          likeBuilder: (bool isLiked) {
                            return SvgPicture.asset(
                              isLiked
                                  ? 'assets/images/profile_page/heart_true.svg'
                                  : 'assets/images/profile_page/heart.svg',
                              colorFilter: ColorFilter.mode(
                                isLiked
                                    ? Colors.red
                                    : const Color.fromARGB(255, 86, 99, 111),
                                BlendMode.srcIn,
                              ),
                            );
                          },
                          onTap: (isLiked) async {
                            try {
                              await postController.likePost(
                                  widget.postId, widget.email);

                              return !isLiked;
                            } catch (e) {
                              print("Error updating like status: $e");

                              return isLiked;
                            }
                          },
                        ),
                        Gap(screenWidth * 0.01),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text('Loading...');
                            }

                            final data = snapshot.data!.data()
                                    as Map<String, dynamic>? ??
                                {};
                            final likeCount =
                                (data['likedBy'] as List?)?.length ?? 0;

                            return Text(
                              '$likeCount likes',
                              style: GoogleFonts.poppins(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                        Gap(screenHeight * 0.02),
                        SvgPicture.asset(
                          'assets/images/profile_page/comment.svg',
                          width: 20.0,
                          height: 20.0,
                        ),
                        Gap(screenWidth * 0.01),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.postId)
                              .collection('comments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            int commentCount = snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0;

                            return Text(
                              '$commentCount comments',
                              style: GoogleFonts.poppins(
                                fontSize: 11.0,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: fetchComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 189, 49, 71),
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'All comments are displayed here.',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                final comments = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final timestamp = comment['commentPublished'] != null
                        ? (comment['commentPublished'] as Timestamp).toDate()
                        : null;
                    final time = timestamp != null
                        ? DateFormat('h:mm a').format(timestamp)
                        : 'Unknown time';

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 40,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 186, 199, 206),
                                  ),
                                  child: (comment['authorImageUrl'] != null &&
                                          comment['authorImageUrl'].isNotEmpty)
                                      ? Image.network(
                                          comment['authorImageUrl'],
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.person, size: 25),
                                ),
                              ),
                              Gap(screenWidth * 0.02),
                              Text(
                                comment['username'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                time,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['commentContent'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 48, 65, 69),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                            thickness: 1.0,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.01,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: screenHeight * 0.06,
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Any thoughts?',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey.shade700,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            top: screenHeight * 0.01,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 248, 248, 248),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 248, 248, 248),
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  TextButton(
                    onPressed: () async {
                      final comment = commentController.text.trim();
                      if (comment.isNotEmpty) {
                        await postController.addComment(
                            widget.postId, widget.email, comment);
                        commentController.clear();
                      } else {
                        print("Comment cannot be empty!");
                      }
                      postController.addComment(
                          widget.postId, widget.email, commentController.text);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'SEND',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 248, 248, 248),
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
