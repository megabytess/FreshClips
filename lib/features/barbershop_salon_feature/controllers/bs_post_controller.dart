import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_post_model.dart';

class BSPostController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// create post and store on firebase
  Future<void> createPost({
    required String content,
    File? postImageFile,
    String? tags,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      print("Current User ID: ${user.uid}");
      final userDoc = await firestore.collection('user').doc(user.uid).get();

      final userData = userDoc.data() ??
          {
            'username': user.email?.split('@')[0] ?? 'Anonymous',
            'imageUrl': '',
          };

      final username = userData['username'];
      final imageUrl = userData['imageUrl'];

      String? postImageUrl;
      if (postImageFile != null) {
        postImageUrl = await uploadImageToFirebase(postImageFile);
      }

      String postId = firestore.collection('posts').doc().id;

      Post newPost = Post(
        id: postId,
        content: content,
        authorId: user.uid,
        authorName: username,
        email: user.email!,
        imageUrl: imageUrl,
        datePublished: DateTime.now(),
        postImageUrl: postImageUrl ?? '',
        tags: tags ?? '',
        likedBy: [],
        commentsCount: 0,
      );

      await firestore
          .collection('posts')
          .doc(postId)
          .set(newPost.toFirestore());
      print("Post created successfully.");
    } catch (e) {
      print("Failed to create post: $e");
      throw Exception("Failed to create post: $e");
    }
  }

  // upload postImage to firebase
  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = storageRef.child('posts/$fileName');

      // Upload the file
      await imageRef.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await imageRef.getDownloadURL();
      print("Image uploaded successfully. Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Image upload failed: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  // get all posts
  Stream<List<Post>> getAllPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map(
      (querySnapshot) {
        return querySnapshot.docs
            .map(
              (doc) => Post.fromFirestore(doc.data(), doc.id),
            )
            .toList();
      },
    );
  }

  // like post and store on firebase
  Future<void> likePost(String postId, String email) async {
    try {
      if (email.isEmpty) {
        throw Exception("User email is required.");
      }

      // Reference to the post document
      final postRef = firestore.collection('posts').doc(postId);

      final postSnapshot = await postRef.get();
      if (!postSnapshot.exists) {
        throw Exception("Post not found.");
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;
      List<dynamic> likedBy = postData['likedBy'] ?? [];

      // Add or remove the email from the likedBy list
      if (likedBy.contains(email)) {
        likedBy.remove(email);
      } else {
        likedBy.add(email);
      }

      // Update the likedBy field in Firestore
      await postRef.update({'likedBy': likedBy});
      print("Post like/unlike status updated successfully.");
    } catch (e) {
      print("Failed to like/unlike post: $e");
      throw Exception("Failed to like/unlike post: $e");
    }
  }

  // Add a comment to the post
  Future<void> addComment(
      String postId, String email, String commentContent) async {
    if (commentContent.trim().isEmpty) {
      print("Content is empty. Add content to proceed.");
      return;
    }

    try {
      final user = auth.currentUser;
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('user').doc(user!.uid).get();
      final userData = userDoc.data() ??
          {
            'username': email.split('@')[0],
            'imageUrl': '',
          };

      final username = userData['username'];
      final imageUrl = userData['imageUrl'];

      final commentsRef =
          firestore.collection('posts').doc(postId).collection('comments');

      await commentsRef.add({
        'authorName': email,
        'username': username,
        'authorImageUrl': imageUrl,
        'commentContent': commentContent,
        'commentPublished': FieldValue.serverTimestamp(),
      });

      print("Comment added successfully!");
    } catch (e) {
      print("Failed to add comment: $e");
      throw Exception("Failed to add comment: $e");
    }
  }

// report account through post
  Future<void> reportAccount({
    required String reporterEmail,
    required String reportedAccountEmail,
    required String postId,
    required String reason,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('reports').add({
        'reporterEmail': reporterEmail,
        'reportedAccountEmail': reportedAccountEmail,
        'postId': postId,
        'reason': reason,
        'timeReported': FieldValue.serverTimestamp(),
      });

      print('Report submitted successfully');
    } catch (e) {
      print('Failed to submit report: $e');
      throw Exception('Failed to submit report: $e');
    }
  }

  // get all posts
  Stream<List<Post>> getSpecificPosts(String email) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('email', isEqualTo: email)
        .snapshots()
        .map(
      (querySnapshot) {
        return querySnapshot.docs
            .map(
              (doc) => Post.fromFirestore(doc.data(), doc.id),
            )
            .toList();
      },
    );
  }
}
