import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickerImage extends StatefulWidget {
  const PickerImage({
    super.key,
    required this.onImagePick,
  });

  final Function(File pickedImage) onImagePick;

  @override
  State<PickerImage> createState() => _PickerImageState();
}

class _PickerImageState extends State<PickerImage> {
  File? _image;

  final _picker = ImagePicker();

  Future getImagePicker() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 600,
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
    // final screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        getImagePicker();
      },
      child: ClipOval(
        child: Container(
          width: screenWidth * 0.3,
          height: screenWidth * 0.3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: _image != null
              ? ClipOval(
                  child: Image.file(
                    _image!.absolute,
                    fit: BoxFit.cover,
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                  ),
                )
              : Icon(
                  Icons.add_photo_alternate_rounded,
                  size: screenWidth *
                      0.1, // Adjust icon size based on screen width
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class PickerImage extends StatefulWidget {
//   const PickerImage({
//     super.key,
//     required this.onImagePick,
//   });

//   final Function(File pickedImage) onImagePick;

//   @override
//   State<PickerImage> createState() => _PickerImageState();
// }

// class _PickerImageState extends State<PickerImage> {
//   File? _pickedImageFile;

//   void _pickImage() async {
//     final pickedImage = await ImagePicker().pickImage(
//         source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);
//     if (pickedImage == null) {
//       return;
//     }

//     setState(() {
//       _pickedImageFile = File(pickedImage.path);
//     });

//     widget.onImagePick(_pickedImageFile!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 80,
//           backgroundColor: Colors.grey,
//           foregroundImage:
//               _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         TextButton.icon(
//           onPressed: _pickImage,
//           icon: const Icon(Icons.image),
//           label: Text(
//             'Select Image',
//             style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 14,
//                 ),
//           ),
//         ),
//       ],
//     );
//   }
// }
