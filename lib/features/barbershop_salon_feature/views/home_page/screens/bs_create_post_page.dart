import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_post_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

final BSPostController postController = BSPostController();

class _CreatePostPageState extends State<CreatePostPage> {
  String selectedHairstyleTag = '';
  File? imagePicker;
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.01,
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      border: Border.all(
                        color: const Color.fromARGB(255, 230, 230, 230),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        TextField(
                          controller: contentController,
                          decoration: InputDecoration(
                            hintText:
                                'Got the fresh cut? Share your experience!',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            color: const Color.fromARGB(255, 48, 48, 48),
                          ),
                          maxLines: 11,
                          keyboardType: TextInputType.multiline,
                        ),
                        if (imagePicker != null)
                          Positioned(
                            top: screenHeight * 0.06,
                            left: screenWidth * 0.01,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imagePicker!,
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.3,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.image_outlined),
                            color: Colors.grey[600],
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              XFile? pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(
                                  () {
                                    imagePicker = File(pickedImage.path);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.02,
              ),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: FloatingActionButton(
                  onPressed: () {
                    postController.createPost(
                      content: contentController.text,
                      postImageFile: imagePicker,
                      tags: selectedHairstyleTag,
                    );
                    Navigator.pop(context);
                  },
                  backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Post',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
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



// Gap(screenHeight * 0.03),
                // Padding(
                //   padding: EdgeInsets.only(left: screenWidth * 0.03),
                //   child: Text(
                //     'Note: For discovery purposes, please select the appropriate hairstyle tags.',
                //     style: GoogleFonts.poppins(
                //       fontSize: screenWidth * 0.03,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
                // Gap(screenHeight * 0.02),
                // Padding(
                //   padding: EdgeInsets.only(left: screenWidth * 0.03),
                //   child: Wrap(
                //     spacing: screenWidth * 0.015,
                //     runSpacing: screenWidth * 0.025,
                //     children: [
                //       'Short & Clean',
                //       'Fades & Tapers',
                //       'Textured & Modern',
                //       'Classic & Timeless',
                //       'Long & Tied',
                //       'Short & Chic',
                //       'Bangs/Fringe Focused',
                //       'Medium Length/Lobs',
                //       'Long & Flowing/Wavy',
                //       'Braided/Updos',
                //     ]
                //         .map(
                //           (style) => AnimatedContainer(
                //             duration: const Duration(milliseconds: 300),
                //             decoration: BoxDecoration(
                //               color: selectedHairstyleTag == style
                //                   ? const Color.fromARGB(255, 48, 65, 69)
                //                   : const Color.fromARGB(255, 230, 230, 230),
                //               borderRadius: BorderRadius.circular(20),
                //               boxShadow: [
                //                 if (selectedHairstyleTag == style)
                //                   BoxShadow(
                //                     color: Colors.black.withOpacity(0.2),
                //                     blurRadius: 6,
                //                     offset: const Offset(0, 3),
                //                   ),
                //               ],
                //             ),
                //             padding: EdgeInsets.symmetric(
                //               vertical: screenWidth * 0.02,
                //               horizontal: screenWidth * 0.04,
                //             ),
                //             child: GestureDetector(
                //               onTap: () {
                //                 setState(() {
                //                   selectedHairstyleTag = style;
                //                 });
                //               },
                //               child: Text(
                //                 style,
                //                 style: GoogleFonts.poppins(
                //                   fontSize: screenWidth * 0.025,
                //                   color: selectedHairstyleTag == style
                //                       ? const Color.fromARGB(255, 248, 248, 248)
                //                       : const Color.fromARGB(255, 48, 65, 69),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         )
                //         .toList(),
                //   ),
                // ),