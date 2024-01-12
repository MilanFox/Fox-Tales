import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/screens/add_group_screen.dart';
import 'package:fox_tales/widgets/atoms/chat_group_teaser.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() {
    return _MessagesScreenState();
  }
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('messages').snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  snapshot.hasError) {
                return const Center(
                  child: Center(child: Text('Data Fetching Error.')),
                );
              }

              final groups =
                  snapshot.data!.docs.firstWhere((doc) => doc.id == 'groups');

              final groupData = groups['groupData']
                  .entries
                  .map((entry) => entry.value as Map<String, dynamic>)
                  .toList();

              final currentUser = FirebaseAuth.instance.currentUser!.uid;
              final filteredGroups = List<Map<String, dynamic>>.from(groupData)
                  .where((element) => element['members'].contains(currentUser))
                  .toList();

              if (filteredGroups.isEmpty) {
                return const Center(
                    child: Text('You have not been added to any groups yet.'));
              }

              return ListView.builder(
                  itemCount: filteredGroups.length,
                  itemBuilder: (ctx, index) {
                    return ChatGroupTeaser(
                      name: filteredGroups[index]['name'],
                      lastMessage: filteredGroups[index]['lastMessage'],
                    );
                  });
            }),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const AddGroupScreen();
              }));
            },
            child: const Icon(
              Icons.add_box,
              size: 50,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
}
