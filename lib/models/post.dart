class Post {
  Post({
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.timeStamp,
  });

  final String description;
  final String imageUrl;
  final String createdAt;
  final int timeStamp;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'timeStamp': timeStamp,
    };
  }
}
