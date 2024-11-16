import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingsReviewController {
  final String clientEmail;
  final TextEditingController reviewController;
  double rating;

  RatingsReviewController({
    required this.clientEmail,
    required this.reviewController,
    this.rating = 0.0,
  });

  Future<void> submitReview(String clientEmail, reviewedEmail) async {
    if (rating > 0 && reviewController.text.isNotEmpty) {
      try {
        // Fetch the client document based on the client's email
        final clientQuerySnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('email',
                isEqualTo: clientEmail) // Use the client's email here
            .get();

        if (clientQuerySnapshot.docs.isNotEmpty) {
          final clientDoc = clientQuerySnapshot.docs.first;

          await FirebaseFirestore.instance.collection('reviews').add({
            'userId': clientDoc.id,
            'rating': rating,
            'reviewText': reviewController.text,
            'timestamp': FieldValue.serverTimestamp(),
            'imageUrl': clientDoc['imageUrl'],
            'username': clientDoc['username'],
            'clientEmail': clientEmail,
            'reviewedEmail': reviewedEmail,
          });
        } else {
          print('Client not found');
        }
      } catch (e) {
        print('Error submitting review: $e');
      }
    } else {
      print('Rating or review text is empty');
    }
  }

  // feteched reviews
  Future<List<Map<String, dynamic>>> fetchAllReviews() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('reviews').get();
    List<Map<String, dynamic>> reviews = [];
    for (var doc in snapshot.docs) {
      print(
          "Review document data: ${doc.data()}"); // Print each document for debugging
      reviews.add(doc.data() as Map<String, dynamic>);
    }
    return reviews;
  }

  // Compute the average rating for the user
  Future<double> computeAverageRating(String reviewedEmail) async {
    try {
      final reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('reviewedEmail',
              isEqualTo: reviewedEmail) // Use reviewedEmail filter
          .get();

      if (reviewsSnapshot.docs.isEmpty) {
        return 0.0;
      }

      double totalRating = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += doc['rating'];
      }

      return totalRating / reviewsSnapshot.docs.length;
    } catch (e) {
      print('Error computing average rating: $e');
      return 0.0;
    }
  }
}
