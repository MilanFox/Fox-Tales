import 'package:flutter/material.dart';
import 'package:fox_tales/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedEntry extends StatelessWidget {
  final Post post;

  const FeedEntry(this.post, {Key? key}) : super(key: key);

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
            Center(
              child: CachedNetworkImage(
                imageUrl: post.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.createdAt,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Visibility(
              visible: post.description.isNotEmpty,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(post.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
