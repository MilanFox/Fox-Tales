import 'package:flutter/material.dart';
import 'package:fox_tales/models/post.dart';

class FeedEntry extends StatelessWidget {
  final Post post;

  const FeedEntry(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(border: Border.all(width: 1)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Image.network(post.imageUrl)),
            const SizedBox(height: 16),
            Text(
              post.createdAt,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(post.description),
          ],
        ),
      ),
    );
  }
}
