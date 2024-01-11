import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_tales/models/user.dart';

class UsersNotifier extends StateNotifier<List<AppUser>> {
  UsersNotifier() : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    final dataSnapshot = await FirebaseFirestore.instance
        .collection('appData')
        .doc('users')
        .get();

    final dataList = dataSnapshot.data()!['list'] as List<dynamic>;

    final users = dataList
        .map((entry) => AppUser(name: entry['name'], uid: entry['uid']))
        .toList();

    state = users;
  }
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, List<AppUser>>((ref) {
  return UsersNotifier();
});
