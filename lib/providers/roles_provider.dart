import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_tales/models/user.dart';

class RolesNotifier extends StateNotifier<Map<String, dynamic>> {
  RolesNotifier() : super({'admins': []}) {
    loadRoles();
  }

  Future<void> loadRoles() async {
    final dataSnapshot = await FirebaseFirestore.instance
        .collection('appData')
        .doc('roles')
        .get();

    state = dataSnapshot.data()!;
  }

  void toggleAdminStatus(AppUser user) async {
    final admins = state['admins'] as List<dynamic>;
    final isAdmin = admins.any((entry) => entry == user.uid);

    if (isAdmin) {
      state = {
        ...state,
        'admins': admins.where((entry) => entry != user.uid).toList()
      };
    } else {
      state = {
        ...state,
        'admins': [...admins, user.uid]
      };
    }

    final userDocRef =
        FirebaseFirestore.instance.collection('appData').doc('roles');

    userDocRef.set(state);
  }
}

final rolesProvider =
    StateNotifierProvider<RolesNotifier, Map<String, dynamic>>((ref) {
  return RolesNotifier();
});
