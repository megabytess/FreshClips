import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSRatingsReviewPage extends StatefulWidget {
  final String clientEmail;

  const BSRatingsReviewPage({super.key, required this.clientEmail});

  @override
  RatingsReviewPageState createState() => RatingsReviewPageState();
}

class RatingsReviewPageState extends State<BSRatingsReviewPage> {
  late RatingsReviewController ratingsReviewController =
      RatingsReviewController(
    clientEmail: widget.clientEmail,
    reviewController: reviewController,
    rating: rating,
  );
  final TextEditingController reviewController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    ratingsReviewController = RatingsReviewController(
      clientEmail: widget.clientEmail,
      reviewController: reviewController,
      rating: rating,
    );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Write a review',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate your experience',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(screenHeight * 0.02),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
            Gap(screenHeight * 0.02),
            TextFormField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Write a review',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
              ),
              maxLines: 5,
            ),
            Gap(screenHeight * 0.04),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
// Define profileId
                  ratingsReviewController.rating = rating;
                  ratingsReviewController.submitReview(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    widget.clientEmail,
                  );

                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Review Submitted',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Your review has been submitted successfully!',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
                ),
                child: Text(
                  'Submit review',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 248, 248, 248),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
