import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/add_multiple_images_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/widget/add_image_hairstylist_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HairstylistPortfolioPage extends StatefulWidget {
  const HairstylistPortfolioPage(
      {super.key, required this.email, required this.isClient});
  final String email;
  final bool isClient;

  @override
  State<HairstylistPortfolioPage> createState() =>
      _HairstylistPortfolioPageState();
}

class _HairstylistPortfolioPageState extends State<HairstylistPortfolioPage> {
  late final AddMultipleImagesController controller;
  String? currentUserEmail;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    controller = AddMultipleImagesController(widget.email, context);
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> deleteImage(String imageUrl, String email) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      QuerySnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      // Check if the 'portfolioImages' field exists
      if (userDoc.docs.isNotEmpty) {
        Map<String, dynamic> data = userDoc.docs.first.data();
        if (data.containsKey('portfolioImages')) {
          DocumentReference userRef = FirebaseFirestore.instance
              .collection('user')
              .doc(userDoc.docs.first.id);
          await userRef.update({
            'portfolioImages': FieldValue.arrayRemove([imageUrl]),
          });
          print('Image deleted successfully.');
        } else {
          print('Field "portfolioImages" does not exist.');
        }
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .where('email', isEqualTo: widget.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 45, 65, 69),
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No images available',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      final userDoc = snapshot.data!.docs.first;
                      final images = List<String>.from((userDoc.data()
                              as Map<String, dynamic>)['portfolioImages'] ??
                          []);

                      if (images.isEmpty) {
                        return Center(
                          child: Text(
                            'No uploaded images',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.02,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return MasonryGridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          images[index],
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 100,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      if (widget.isClient &&
                                          currentUserEmail == widget.email)
                                        Positioned(
                                          top: 20,
                                          right: 20,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 248, 248, 248),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Color.fromARGB(
                                                    255, 45, 65, 69),
                                              ),
                                              onPressed: () async {
                                                final confirmed =
                                                    await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                      'Delete Image',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  18, 18, 18),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to delete this image?',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  18, 18, 18),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    18,
                                                                    18,
                                                                    18),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirmed) {
                                                  await deleteImage(
                                                      images[index],
                                                      widget.email);
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image,
                                      color: Colors.grey, size: 50);
                                },
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

            // Positioned Add Image Button
            if (currentUserEmail == widget.email)
              Positioned(
                bottom: screenWidth * 0.04,
                right: screenWidth * 0.04,
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.12,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 45, 65, 69),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddImagePage(email: widget.email),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: const Color.fromARGB(255, 248, 248, 249),
                          size: screenWidth * 0.05,
                        ),
                        Gap(screenWidth * 0.01),
                        Text(
                          'Add image',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 248, 248, 249),
                          ),
                        ),
                      ],
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
