import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_post_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_post_model.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/screens/bs_comments_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/screens/bs_create_post_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/widgets/bs_haircut_ideas_categories_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

class HairstylistHomePage extends StatefulWidget {
  const HairstylistHomePage({super.key, required this.email});
  final String email;
  @override
  State<HairstylistHomePage> createState() => _HairstylistHomePageState();
}

final BarbershopSalonController barbershopsalonController =
    BarbershopSalonController();
final BSPostController postController = BSPostController();

class _HairstylistHomePageState extends State<HairstylistHomePage> {
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
                Gap(screenHeight * 0.02),
                Container(
                  width: screenWidth * 0.96,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 186, 199, 206),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  child: Stack(
                    children: [
                      // Background image
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      //   child: Image.asset(
                      //     'assets/images/icons/inspiration_img.jpg',
                      //     width: screenWidth * 0.95,
                      //     height: screenHeight * 0.2,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Color.fromARGB(255, 186, 199, 206),
                      //     // Colors.black.withOpacity(0.6),
                      //     borderRadius:
                      //         BorderRadius.circular(screenWidth * 0.05),
                      //   ),
                      // ),
                      Positioned(
                        top: screenHeight * 0.019,
                        left: screenWidth * 0.03,
                        child: Text(
                          '  Hairstyle ideas',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 48, 65, 69),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight * 0.014,
                        right: screenWidth * 0.035,
                        child: SizedBox(
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.03,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HaircutIdeasCategories(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color.fromARGB(255, 48, 65, 69),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Explore',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.022,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.01,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
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
                                    Gap(screenWidth * 0.02),
                                    Text(
                                      post.authorName ?? 'Unknown',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 18, 18, 18),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.1,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.content,
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.03,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      Gap(screenHeight * 0.01),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: post.postImageUrl != null &&
                                                post.postImageUrl!.isNotEmpty
                                            ? Image.network(
                                                post.postImageUrl!,
                                                width: screenWidth * 0.9,
                                                height: screenHeight * 0.3,
                                                fit: BoxFit.fitWidth,
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      Gap(screenHeight * 0.01),
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
                                      Gap(screenHeight * 0.02),
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
                                                colorFilter: ColorFilter.mode(
                                                  isLiked
                                                      ? Colors.red
                                                      : const Color.fromARGB(
                                                          255, 86, 99, 111),
                                                  BlendMode.srcIn,
                                                ),
                                              );
                                            },
                                            onTap: (isLiked) async {
                                              if (isLiked) {
                                                post.likedBy
                                                    .remove(widget.email);
                                              } else {
                                                post.likedBy.add(widget.email);
                                              }

                                              await postController.likePost(
                                                post.id,
                                                widget.email,
                                              );
                                              return !isLiked;
                                            },
                                          ),
                                          Gap(screenHeight * 0.02),
                                          SvgPicture.asset(
                                            'assets/images/profile_page/comment.svg',
                                            width: 20.0,
                                            height: 20.0,
                                          ),
                                          Gap(screenHeight * 0.01),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(post.id)
                                                .collection('comments')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              int commentCount = snapshot
                                                      .hasData
                                                  ? snapshot.data!.docs.length
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
                                ),
                              ],
                            ),
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
