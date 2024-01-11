import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fox_tales/models/user.dart';
import 'package:fox_tales/widgets/molecules/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() {
    return _UsersScreenState();
  }
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appData')
            .doc('users')
            .snapshots(),
        builder: (ctx, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!usersSnapshot.hasData) {
            return const Center(child: Text('Can\'t access user list.'));
          }

          final data = usersSnapshot.data!['list'] as List<dynamic>;

          final userList = data
              .map((entry) => AppUser(name: entry['name'], uid: entry['uid']))
              .toList();

          return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (ctx, index) {
                return UserCard(userList[index]);
              });
        },
      ),
    );
  }
}
