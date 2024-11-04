import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/add_multiple_images_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/widget/add_image_hairstylist_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HairstylistPortfolioPage extends StatefulWidget {
  const HairstylistPortfolioPage({super.key, required this.email});
  final String email;

  @override
  State<HairstylistPortfolioPage> createState() =>
      _HairstylistPortfolioPageState();
}

class _HairstylistPortfolioPageState extends State<HairstylistPortfolioPage> {
  List<String> images = [];
  bool isLoading = true;

  late final AddMultipleImagesController controller;

  @override
  void initState() {
    super.initState();
    controller = AddMultipleImagesController(widget.email, context);
    fetchImages();
  }

  Future<void> fetchImages() async {
    setState(() {
      isLoading = true;
    });

    List<String> fetchedImages = await controller.fetchImages();

    setState(() {
      images = fetchedImages;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Stack(
          children: [
            // This is the grid of images
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: images.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No uploaded images',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                itemCount: images.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          screenHeight * 0.02),
                                      image: DecorationImage(
                                        image: NetworkImage(images[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),

            // Positioned Delete Button
            // Positioned(
            //     bottom: screenWidth * 0.04,
            //     right: screenWidth * 0.35,
            //     child: OutlinedButton(
            //       onPressed: () {
            //         // Implement your delete functionality here
            //         print('Delete action triggered');
            //       },
            //       style: OutlinedButton.styleFrom(
            //         side: const BorderSide(
            //           color: Color.fromARGB(255, 189, 49, 71),
            //           width: 2.0,
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(screenWidth * 0.04),
            //         ),
            //         padding: EdgeInsets.symmetric(
            //           horizontal: screenWidth * 0.04,
            //           vertical: screenWidth * 0.02,
            //         ),
            //         shadowColor: Colors.black.withOpacity(0.2),
            //         elevation: 5,
            //       ),
            //       child: Icon(
            //         Icons.delete,
            // color: const Color.fromARGB(255, 45, 65, 69),
            //         color: const Color.fromARGB(255, 189, 49, 71),
            //         size: screenWidth * 0.06,
            //       ),
            //     )),

            // Positioned Add Image Button
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
                        builder: (context) => AddImagePage(email: widget.email),
                      ),
                    ).then((_) {
                      fetchImages();
                    });
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
