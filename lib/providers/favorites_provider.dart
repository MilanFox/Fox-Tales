import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/models/post.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'favorites.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE favorite_posts(timeStamp INT PRIMARY KEY, imageUrl TEXT, createdAt TEXT, description TEXT)');
    },
    version: 1,
  );

  return db;
}

class FavoritesNotifier extends StateNotifier<List<Post>> {
  FavoritesNotifier() : super([]) {
    loadFavorites();
  }

  void loadFavorites() async {
    final db = await _getDatabase();
    final data = await db.query('favorite_posts');
    final favorites = data
        .map((entry) => Post(
            createdAt: entry['createdAt'] as String,
            description: entry['description'] as String,
            imageUrl: entry['imageUrl'] as String,
            timeStamp: entry['timeStamp'] as int))
        .toList();
    state = favorites;
  }

  void toggleFavoriteStatus(Post post) async {
    final isFavorite = state.any((entry) => entry.timeStamp == post.timeStamp);
    final db = await _getDatabase();

    if (isFavorite) {
      state =
          state.where((entry) => entry.timeStamp != post.timeStamp).toList();

      await db.delete('favorite_posts', where: 'timeStamp = ${post.timeStamp}');
    } else {
      state = [...state, post];

      db.insert('favorite_posts', {
        'timeStamp': post.timeStamp,
        'imageUrl': post.imageUrl,
        'createdAt': post.createdAt,
        'description': post.description,
      });
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Post>>((ref) {
  return FavoritesNotifier();
});
