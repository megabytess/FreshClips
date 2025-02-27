import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_post_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_post_model.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/screens/bs_comments_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/screens/bs_create_post_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class BSHomePage extends StatefulWidget {
  const BSHomePage({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<BSHomePage> createState() => _BSHomePageState();
}

final BarbershopSalonController barbershopsalonController =
    BarbershopSalonController();
final BSPostController postController = BSPostController();

class _BSHomePageState extends State<BSHomePage> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barbershopsalonController.getBarbershopSalon(widget.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: barbershopsalonController,
      builder: (context, snapshot) {
        if (barbershopsalonController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Container(
                //   width: screenWidth * 0.96,
                //   height: screenHeight * 0.06,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 186, 199, 206),
                //     borderRadius: BorderRadius.circular(screenWidth * 0.04),
                //   ),
                //   child: Stack(
                //     children: [
                //       Positioned(
                //         top: screenHeight * 0.019,
                //         left: screenWidth * 0.03,
                //         child: Text(
                //           '  Hairstyle ideas',
                //           style: GoogleFonts.poppins(
                //             fontSize: screenWidth * 0.035,
                //             fontWeight: FontWeight.w600,
                //             color: const Color.fromARGB(255, 48, 65, 69),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         bottom: screenHeight * 0.014,
                //         right: screenWidth * 0.035,
                //         child: SizedBox(
                //           width: screenWidth * 0.2,
                //           height: screenHeight * 0.03,
                //           child: OutlinedButton(
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) =>
                //                       HaircutIdeasCategories(),
                //                 ),
                //               );
                //             },
                //             style: OutlinedButton.styleFrom(
                //               side: const BorderSide(
                //                 color: Color.fromARGB(255, 48, 65, 69),
                //                 width: 1,
                //               ),
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(20),
                //               ),
                //             ),
                //             child: Text(
                //               'Explore',
                //               style: GoogleFonts.poppins(
                //                 fontSize: screenWidth * 0.022,
                //                 fontWeight: FontWeight.w500,
                //                 color: const Color.fromARGB(255, 48, 65, 69),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Gap(screenHeight * 0.01),
                // Divider(
                //   color: Colors.grey[300],
                //   thickness: 1,
                // ),
                Gap(screenHeight * 0.01),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                      child: ClipOval(
                        child: Container(
                          width: screenWidth * 0.14,
                          height: screenWidth * 0.14,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 186, 199, 206),
                          ),
                          child: (barbershopsalonController
                                          .barbershopsalon?.imageUrl !=
                                      null &&
                                  barbershopsalonController
                                      .barbershopsalon!.imageUrl.isNotEmpty)
                              ? Image.network(
                                  barbershopsalonController
                                      .barbershopsalon!.imageUrl,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 25),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePostPage(),
                            ),
                          ),
                          child: Text(
                            'Got the fresh cut? Share your experience!',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.01),
                StreamBuilder<List<Post>>(
                  stream: postController.getAllPosts(),
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

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'All posts are displayed here.',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final posts = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BSCommentPage(
                                  email: widget.email,
                                  postId: post.id,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                      vertical: screenHeight * 0.02,
                                    ),
                                    child: ClipOval(
                                      child: Container(
                                        width: 35.0,
                                        height: 35.0,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 186, 199, 206),
                                        ),
                                        child: (post.imageUrl.isNotEmpty)
                                            ? Image.network(
                                                post.imageUrl,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.person,
                                                size: 25),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: screenHeight * 0.02,
                                            ),
                                            child: Text(
                                              post.authorName ?? 'Unknown',
                                              style: GoogleFonts.poppins(
                                                color: const Color.fromARGB(
                                                    255, 48, 65, 69),
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Gap(screenWidth * 0.02),
                                          // Time Icon and Duration
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: screenHeight * 0.02,
                                            ),
                                            child: Container(
                                              width: screenWidth * 0.01,
                                              height: screenHeight * 0.01,
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    100, 48, 65, 69),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Gap(screenWidth * 0.015),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: screenHeight * 0.02,
                                            ),
                                            child: Text(
                                              DateFormat('h:mm a')
                                                  .format(post.datePublished),
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.025,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    100, 48, 65, 69),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: screenHeight * 0.005,
                                          bottom: screenHeight * 0.01,
                                        ),
                                        child: Text(
                                          post.content,
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 48, 65, 69),
                                            fontSize: screenWidth * 0.030,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: post.postImageUrl != null &&
                                                post.postImageUrl!.isNotEmpty
                                            ? Image.network(
                                                post.postImageUrl!,
                                                width: screenWidth * 0.82,
                                                height: screenHeight * 0.3,
                                                fit: BoxFit.cover,
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      Gap(screenHeight * 0.008),
                                      post.tags?.isNotEmpty == true
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.03,
                                                vertical: screenHeight * 0.005,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 217, 217, 217),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                post.tags!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.023,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color.fromARGB(
                                                      255, 86, 99, 111),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      Gap(screenHeight * 0.01),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              LikeButton(
                                                size: 20,
                                                likeCount: post.likedBy.length,
                                                isLiked: post.likedBy
                                                    .contains(widget.email),
                                                likeBuilder: (bool isLiked) {
                                                  return SvgPicture.asset(
                                                    isLiked
                                                        ? 'assets/images/profile_page/heart_true.svg'
                                                        : 'assets/images/profile_page/heart.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      isLiked
                                                          ? Colors.red
                                                          : const Color
                                                              .fromARGB(
                                                              255, 86, 99, 111),
                                                      BlendMode.srcIn,
                                                    ),
                                                  );
                                                },
                                                onTap: (isLiked) async {
                                                  try {
                                                    final postId = post.id;
                                                    if (postId.isNotEmpty) {
                                                      await postController
                                                          .likePost(postId,
                                                              widget.email);
                                                      return !isLiked;
                                                    } else {
                                                      print("Invalid post ID");
                                                      return isLiked;
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        "Error updating like status: $e");
                                                    return isLiked;
                                                  }
                                                },
                                              ),
                                              Gap(screenHeight * 0.02),
                                              SvgPicture.asset(
                                                'assets/images/profile_page/comment.svg',
                                                width: 20.0,
                                                height: 20.0,
                                              ),
                                              Gap(screenWidth * 0.005),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('posts')
                                                    .doc(post.id)
                                                    .collection('comments')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  int commentCount =
                                                      snapshot.hasData
                                                          ? snapshot
                                                              .data!.docs.length
                                                          : 0;

                                                  return Text(
                                                    '$commentCount',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[500],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
