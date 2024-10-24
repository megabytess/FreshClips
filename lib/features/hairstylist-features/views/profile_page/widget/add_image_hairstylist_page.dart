import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/add_multiple_images_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key, required this.email});
  final String email;

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  List<File> _selectedImages = [];
  final ImagePicker picker = ImagePicker();
  bool _isLoading = false;

  late final AddMultipleImagesController controller;

  @override
  void initState() {
    super.initState();
    controller = AddMultipleImagesController(widget.email, context);
  }

  void pickImages() async {
    // Pick multiple images using ImagePicker
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      if (mounted) {
        setState(() {
          // Convert XFile list to File list and store in _selectedImages
          _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
          controller.addSelectedImages(_selectedImages);
        });
      }
    } else {
      print('No images selected.');
    }
  }

  void uploadImages() async {
    setState(() {
      _isLoading = true;
    });

    await controller.uploadImages();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add images',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: pickImages,
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: screenWidth * 0.04,
                    color: const Color.fromARGB(255, 189, 49, 71),
                  ),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Text(
                    'Add image',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 189, 49, 71),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Gap(screenWidth * 0.04),
                Expanded(
                  child: _selectedImages.isEmpty
                      ? Center(
                          child: Text(
                            'No images selected',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: _selectedImages.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: screenWidth * 0.01,
                            mainAxisSpacing: screenWidth * 0.01,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                                image: DecorationImage(
                                  image: FileImage(_selectedImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    uploadImages();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.15,
                      vertical: screenWidth * 0.035,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                  ),
                  child: Text(
                    'Upload image',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                  ),
                ),
                Gap(screenWidth * 0.04),
              ],
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 189, 49, 71)),
                ),
              ),
          ],
        ));
  }
}
