import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/providers/favorites_provider.dart';
import 'package:fox_tales/widgets/atoms/feed_entry.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() {
    return _FavoritesScreenState();
  }
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = List.from(ref.watch(favoritesProvider));
    favorites.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (ctx, index) {
        return FeedEntry(favorites[index]);
      },
    );
  }
}
