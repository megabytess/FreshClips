import 'package:flutter/material.dart';

class HairstylistPortfolioPage extends StatefulWidget {
  const HairstylistPortfolioPage({super.key});

  @override
  State<HairstylistPortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<HairstylistPortfolioPage> {
  final List<String> images = [
    'assets/images/profile_page/sample_pic.jpg',
    'assets/images/profile_page/sample_pic.jpg',
    'assets/images/profile_page/sample_pic.jpg',
    'assets/images/profile_page/sample_pic.jpg',
    'assets/images/profile_page/sample_pic.jpg',
    'assets/images/profile_page/sample_pic.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: GridView.builder(
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 images per row
            crossAxisSpacing: 8.0, // space between images horizontally
            mainAxisSpacing: 8.0, // space between images vertically
            childAspectRatio: 1.0, // aspect ratio to maintain square images
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic for adding or uploading images
          _uploadPicture(context);
        },
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        child: const Icon(
          Icons.add,
          color: const Color.fromARGB(255, 189, 49, 71),
        ),
      ),
    );
  }

  void _uploadPicture(BuildContext context) {
    // You can use image_picker package or any other image upload logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Picture'),
          content: Text('Choose from gallery or take a new photo.'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle selecting from gallery
                Navigator.of(context).pop();
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                // Handle taking a new photo
                Navigator.of(context).pop();
              },
              child: Text('Camera'),
            ),
          ],
        );
      },
    );
  }
}
