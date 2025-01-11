import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final String authorId;
  final String? authorName;
  final DateTime datePublished;
  final String? postImageUrl;
  final String imageUrl;
  final String email;
  final List<String> likedBy;
  final int commentsCount;
  final String? tags;
  final bool isPublished;

  Post({
    required this.id,
    required this.content,
    required this.authorId,
    this.authorName,
    required this.email,
    required this.datePublished,
    this.postImageUrl,
    required this.imageUrl,
    this.commentsCount = 0,
    this.likedBy = const [],
    this.tags,
    this.isPublished = true,
  });

  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'],
      email: data['email'],
      datePublished: (data['datePublished'] as Timestamp).toDate(),
      postImageUrl: data['postImageUrl'],
      imageUrl: data['imageUrl'],
      commentsCount: data['commentsCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      tags: (data['tags'] ?? '').trim(),
      isPublished: data['isPublished'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'email': email,
      'datePublished': datePublished,
      'postImageUrl': postImageUrl,
      'imageUrl': imageUrl,
      'likedBy': likedBy,
      'commentsCount': commentsCount,
      'tags': tags,
      'isPublished': isPublished,
    };
  }
}
