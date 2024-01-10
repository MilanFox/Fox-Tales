import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/models/post.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

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
    loadLocalFavorites();
  }

  void loadLocalFavorites() async {
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

  void updateLocalFavorites(List<Post> favorites) async {
    final db = await _getDatabase();
    await db.delete('favorite_posts');
    for (final post in favorites) {
      await db.insert('favorite_posts', {
        'timeStamp': post.timeStamp,
        'imageUrl': post.imageUrl,
        'createdAt': post.createdAt,
        'description': post.description,
      });
    }
  }

  Future<void> loadRemoteFavorites() async {
    final dataSnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final data = dataSnapshot.data()!['favorites'] as List<dynamic>;

    final favorites = data
        .map((entry) => Post(
            createdAt: entry['createdAt'] as String,
            description: entry['description'] as String,
            imageUrl: entry['imageUrl'] as String,
            timeStamp: entry['timeStamp'] as int))
        .toList();

    state = favorites;
    updateLocalFavorites(favorites);
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

      await db.insert('favorite_posts', {
        'timeStamp': post.timeStamp,
        'imageUrl': post.imageUrl,
        'createdAt': post.createdAt,
        'description': post.description,
      });
    }

    final userDocRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    userDocRef.set({'favorites': state.map((post) => post.toMap()).toList()});
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Post>>((ref) {
  return FavoritesNotifier();
});
