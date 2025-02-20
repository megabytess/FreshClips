import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_add_ratings_review_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_sort_ratings_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSReviewPage extends StatefulWidget {
  const BSReviewPage({
    super.key,
    required this.clientEmail,
    required this.isClient,
    required this.email,
  });

  final String clientEmail;
  final bool isClient;
  final String email;

  @override
  State<BSReviewPage> createState() => _BSReviewPageState();
}

class _BSReviewPageState extends State<BSReviewPage> {
  late TextEditingController reviewController;
  late double rating;
  late RatingsReviewController ratingsReviewController;
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
    rating = 0.0;
    ratingsReviewController = RatingsReviewController(
      clientEmail: widget.clientEmail,
      reviewController: reviewController,
      rating: rating,
    );
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      right: screenWidth * 0.05,
                      left: screenWidth * 0.05,
                    ),
                    child: Text(
                      'Reviews',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 45, 65, 69),
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  SizedBox(
                    height: screenHeight * 0.03,
                    width: screenWidth * 0.18,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BSSortRatingPage(
                            email: widget.email,
                            clientEmail: widget.clientEmail,
                          );
                        }));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 48, 65, 69), width: 1),
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.001,
                          left: screenWidth * 0.04,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Sort',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.022,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                          Gap(screenWidth * 0.02),
                          const Icon(
                            Icons.sort,
                            size: 14,
                            color: Color.fromARGB(255, 48, 65, 69),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(screenHeight * 0.02),
                ],
              ),
              Gap(screenWidth * 0.38),
              if (currentUserEmail != null &&
                  currentUserEmail != widget.clientEmail)
                SizedBox(
                  width: screenWidth * 0.32,
                  height: screenHeight * 0.035,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 48, 65, 69),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BSRatingsReviewPage(
                            clientEmail: widget.clientEmail,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Leave a Review',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 48, 65, 69),
                        fontSize: screenWidth * 0.023,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: ratingsReviewController.fetchAccountReviewss(
                widget.clientEmail, widget.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 189, 49, 71)),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No reviews available',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else {
                final reviews = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      final String username =
                          review['username'] ?? 'Unknown User';
                      final String imageUrl = review['imageUrl'] ?? '';
                      final String reviewText = review['reviewText'] ?? '';
                      final double rating =
                          (review['rating'] ?? 0.0).toDouble();

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.035,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.001,
                            ),
                            child: ClipOval(
                              child: (imageUrl.isNotEmpty)
                                  ? Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/no_image.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      username,
                                      style: GoogleFonts.poppins(
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      rating.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.014,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/profile_page/star.svg',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Client',
                                  style: GoogleFonts.poppins(
                                    color:
                                        const Color.fromARGB(100, 48, 65, 69),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.008,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.010,
                                  ),
                                  child: Text(
                                    reviewText,
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 48, 65, 69),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.030,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
