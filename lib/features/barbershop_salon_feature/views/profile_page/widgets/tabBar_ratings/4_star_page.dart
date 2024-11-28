import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class FourStarPage extends StatelessWidget {
  const FourStarPage(
      {super.key, required this.email, required this.clientEmail});
  final String email;
  final String clientEmail;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    RatingsReviewController ratingsReviewController = RatingsReviewController(
        clientEmail: '', reviewController: TextEditingController());
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ratingsReviewController
            .fetchRatingFour(clientEmail, email)
            .asStream(),
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
              child: Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.05),
                child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    final String username =
                        review['username'] ?? 'Unknown User';
                    final String imageUrl = review['imageUrl'] ?? '';
                    final String reviewText = review['reviewText'] ?? '';
                    final double rating = (review['rating'] ?? 0.0).toDouble();

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.035,
                            vertical: screenHeight * 0.001,
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
                                      color:
                                          const Color.fromARGB(255, 18, 18, 18),
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    rating.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.014,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 18, 18, 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: screenWidth * 0.01,
                                      right: screenWidth * 0.02,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/images/profile_page/star.svg',
                                      width: MediaQuery.of(context).size.width *
                                          0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Client',
                                style: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 118, 118, 118),
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: screenHeight * 0.008,
                                  bottom: screenHeight * 0.010,
                                ),
                                child: Text(
                                  reviewText,
                                  style: GoogleFonts.poppins(
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
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
              ),
            );
          }
        },
      ),
    );
  }
}
