import 'package:flutter/material.dart';
import 'package:fox_tales/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fox_tales/providers/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedEntry extends ConsumerStatefulWidget {
  final Post post;

  const FeedEntry(this.post, {super.key});

  @override
  ConsumerState<FeedEntry> createState() {
    return _FeedEntryState();
  }
}

class _FeedEntryState extends ConsumerState<FeedEntry> {
  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);

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
                imageUrl: widget.post.imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  widget.post.createdAt,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                GestureDetector(
                  child: favorites.any(
                          (entry) => entry.timeStamp == widget.post.timeStamp)
                      ? const Icon(Icons.star)
                      : const Icon(Icons.star_border_outlined),
                  onTap: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggleFavoriteStatus(widget.post);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Visibility(
              visible: widget.post.description.isNotEmpty,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(widget.post.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
