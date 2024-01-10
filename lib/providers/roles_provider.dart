import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RolesNotifier extends StateNotifier<Map<String, dynamic>> {
  RolesNotifier() : super({'admins': [], 'isAdmin': false}) {
    loadRemoteFavorites();
  }

  Future<void> loadRemoteFavorites() async {
    final dataSnapshot = await FirebaseFirestore.instance
        .collection('appData')
        .doc('roles')
        .get();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final isAdmin = dataSnapshot.data()!['admins'].contains(uid);

    state = {
      ...dataSnapshot.data()!,
      'isAdmin': isAdmin,
    };
  }
}

final rolesProvider =
    StateNotifierProvider<RolesNotifier, Map<String, dynamic>>((ref) {
  return RolesNotifier();
});
