import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RectanglePickerImage extends StatefulWidget {
  const RectanglePickerImage({
    super.key,
    required this.onImagePick,
  });

  final Function(File pickedImage) onImagePick;

  @override
  State<RectanglePickerImage> createState() => _RectanglePickerImageState();
}

class _RectanglePickerImageState extends State<RectanglePickerImage> {
  File? rectangleImage;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 600,
    );

    if (pickedFile != null) {
      setState(() {
        rectangleImage = File(pickedFile.path);
      });
      widget.onImagePick(rectangleImage!);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: screenWidth * 0.5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: rectangleImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  rectangleImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.add_photo_alternate_rounded,
                size: screenWidth * 0.1,
                color: Colors.grey,
              ),
      ),
    );
  }
}
