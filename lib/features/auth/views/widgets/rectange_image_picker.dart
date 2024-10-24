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
  State<RectanglePickerImage> createState() => _PickerImageState();
}

class _PickerImageState extends State<RectanglePickerImage> {
  File? _image;

  final _picker = ImagePicker();

  Future getImagePickerRectangle() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.onImagePick(
            _image!); // Notify the parent widget of the selected image
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        getImagePickerRectangle();
      },
      child: Container(
        width: screenWidth * 0.3,
        height: screenWidth * 0.3,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15), // Rounded square
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15), // Matching radius
                child: Image.file(
                  _image!.absolute,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                ),
              )
            : Icon(
                Icons.add_photo_alternate_rounded,
                size:
                    screenWidth * 0.1, // Adjust icon size based on screen width
                color: Colors.grey,
              ),
      ),
    );
  }
}
