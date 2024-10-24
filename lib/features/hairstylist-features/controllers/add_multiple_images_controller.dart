import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddMultipleImagesController {
  final String email;
  final BuildContext context;

  AddMultipleImagesController(this.email, this.context);

  List<File> selectedImages = [];

  Future<void> uploadImages() async {
    try {
      List<String> downloadUrls = [];

      for (File image in selectedImages) {
        String fileName = '$email/${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef =
            FirebaseStorage.instance.ref().child('user_portfolio/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = querySnapshot.docs.first.reference;
        await userDocRef.set({
          'portfolioImages': FieldValue.arrayUnion(downloadUrls),
        }, SetOptions(merge: true));

        print('Success: Images uploaded successfully!');
        selectedImages.clear();
      } else {
        print('Error: No user found with the provided email.');
      }
    } catch (e) {
      print('Error: Failed to upload images. $e');
    }
  }

  Future<List<String>> fetchImages() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        List<dynamic> portfolioImages = userDoc['portfolioImages'] ?? [];
        return List<String>.from(portfolioImages);
      } else {
        print('Error: No user found with the provided email.');
        return [];
      }
    } catch (e) {
      print('Error fetching images: $e');
      return [];
    }
  }

  void addSelectedImages(List<File> images) {
    selectedImages.addAll(images);
  }
}
