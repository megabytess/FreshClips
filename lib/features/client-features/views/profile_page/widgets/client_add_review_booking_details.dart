import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientRatingsReviewPage extends StatefulWidget {
  final String clientEmail;
  final String userEmail;

  const ClientRatingsReviewPage({
    super.key,
    required this.clientEmail,
    required this.userEmail,
  });

  @override
  RatingsReviewPageState createState() => RatingsReviewPageState();
}

class RatingsReviewPageState extends State<ClientRatingsReviewPage> {
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

  void submitReview(String clientEmail, String userEmail) async {
    if (rating > 0 && reviewController.text.isNotEmpty) {
      try {
        // Fetch the appointment document where clientEmail matches
        final appointmentSnapshot = await FirebaseFirestore.instance
            .collection('appointments')
            .where('bookedUser', isEqualTo: userEmail)
            .get();

        if (appointmentSnapshot.docs.isEmpty) {
          print('Appointment not found for the given clientEmail');
          return;
        }

        // Get the first matching appointment
        final appointmentDoc = appointmentSnapshot.docs.first;
        final appointmentData = appointmentDoc.data();
        final barberEmail = appointmentData['bookedUser'] ?? '';

        if (barberEmail.isEmpty) {
          print(
              'Booked user email (barber) is missing in the appointment data');
          return;
        }

        print('Barber Email: $barberEmail');

        // Fetch the client document
        final userQuerySnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: clientEmail)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final clientDoc = userQuerySnapshot.docs.first;
          final imageUrl = clientDoc.data()['imageUrl'] ?? '';
          final username = clientDoc.data()['username'] ?? 'Anonymous';

          // Add the review document
          await FirebaseFirestore.instance.collection('reviews').add({
            'rating': rating,
            'reviewText': reviewController.text,
            'timestamp': FieldValue.serverTimestamp(),
            'imageUrl': imageUrl,
            'username': username,
            'clientEmail': clientEmail,
            'reviewedEmail':
                barberEmail, // Store the email of the person being reviewed (the barber)
          });

          print('Review added successfully');
        } else {
          print('Client not found in user collection');
        }
      } catch (e) {
        print('Error adding review: $e');
      }
    } else {
      print('Rating or review text is empty');
    }
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
                  try {
                    final clientEmail =
                        FirebaseAuth.instance.currentUser?.email ?? '';
                    // final email = widget.clientEmail;
                    final email = widget.userEmail;

                    print('Client Email: $clientEmail');
                    print('Reviewed Email: $email');

                    Navigator.pop(context);
                    if (clientEmail.isNotEmpty && email.isNotEmpty) {
                      submitReview(clientEmail, widget.userEmail);
                    } else {
                      print('Either clientEmail or reviewedEmail is empty');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Unable to submit review. Please try again later.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    print('Error submitting review: $e');
                  }
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
