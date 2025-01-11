class Tag {
  final String id;
  final String name;
  final List<String> postIds;

  Tag({
    required this.id,
    required this.name,
    required this.postIds,
  });

  factory Tag.fromFirestore(Map<String, dynamic> data, String id) {
    return Tag(
      id: id,
      name: data['name'] ?? '',
      postIds: List<String>.from(data['postIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'postIds': postIds,
    };
  }
}
