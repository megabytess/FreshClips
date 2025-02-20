import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HaircutIdeasCategories extends StatelessWidget {
  const HaircutIdeasCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final categories = [
      'Short & Clean',
      'Fades & Tapers',
      'Textured & Modern',
      'Classic & Timeless',
      'Long & Tied',
      'Short & Chic',
      'Bangs/Fringe Focused',
      'Medium Length/Lobs',
      'Long & Flowing/Wavy',
      'Braided/Updos',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Haircut Ideas',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
            child: Text(
              'Browse by Category',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
            ),
          ),
          Gap(screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    // Handle category tap
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 186, 199, 206),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.03,
                              screenHeight * 0.02,
                              screenWidth * 0.03,
                              screenHeight * 0.02),
                          child: Text(
                            category,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                        ),
                        Positioned(
                          right: screenWidth * 0.03,
                          bottom: screenHeight * 0.015,
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: Color.fromARGB(255, 48, 65, 69),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
