import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RolesNotifier extends StateNotifier<Map<String, dynamic>> {
  RolesNotifier() : super({'admins': []}) {
    loadRemoteFavorites();
  }

  Future<void> loadRemoteFavorites() async {
    final dataSnapshot = await FirebaseFirestore.instance
        .collection('appData')
        .doc('roles')
        .get();

    state = dataSnapshot.data()!;
  }
}

final rolesProvider =
    StateNotifierProvider<RolesNotifier, Map<String, dynamic>>((ref) {
  return RolesNotifier();
});
