class Post {
  Post(
      {required this.description,
      required this.imageUrl,
      required this.createdAt,
      required this.timeStamp});

  final String description;
  final String imageUrl;
  final String createdAt;
  final int timeStamp;
}
